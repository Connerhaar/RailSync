//
//  LoginView.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI



struct LoginScreen: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var navController = NavController.shared
    @StateObject private var loginViewModel = LoginViewModel()
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var pageState: PageState = .login
    @State private var isLoading: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    
    @State private var invalidEmail: Bool = false
    @State private var emailAlreadyExists: Bool = false
    @State private var invalidPassword: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField {
        case emailFocus, passwordFocus
    }
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [Color.t300, Color.t700],
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focusedField = nil
                }
                
                VStack{
                    Spacer().frame(height: 100)
                    
                    
                    let title: String = if(pageState == .login){"Welcome"} else {"Sign Up"}
                    Text(title)
                        .font(.custom("Large", size: 40))
                        .foregroundStyle(Color.b100)
                    
                    
                    VStack(alignment: .leading) {
                        
                        // Email TextField
                        HStack(alignment: .center){
                            Image(systemName: "envelope")
                                .renderingMode(.template)
           
                                .foregroundStyle(Color.b800)
                                .frame(width: 20, height: 20)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                            
                            
                            TextField("Email Address", text: $emailAddress)
                                .font(.custom("Helvetica", size: 14))
                                .padding(.vertical, 10)
                                .textContentType(.emailAddress)
                                .focused($focusedField, equals: .emailFocus)
                                .onChange(of: emailAddress){
                                    invalidEmail = false
                                }
                                .onSubmit{
                                    focusedField = .passwordFocus
                                }
                                
                        }
                        .overlay(RoundedRectangle(cornerRadius:5).stroke(Color.b700, lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        if(invalidEmail){
                            Text("Invalid email")
                                .font(.footnote)
                                .foregroundStyle(Color.red)
                                .padding(.leading, 25)
                        }
                        
                        if(emailAlreadyExists){
                            Text("Email address already in use")
                                .font(.footnote)
                                .foregroundStyle(Color.red)
                                .padding(.horizontal, 25)
                        }
                        
                        // Password TextField
                        HStack(alignment: .center){
                            Image(systemName: "lock")
                                .renderingMode(.template)
                                .scaleEffect(1.3)
                                .foregroundStyle(Color.b800)
                                .frame(width: 20, height: 20)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                            
                            if(isPasswordVisible){
                                TextField("Password", text: $password)
                                    .font(.custom("Helvetica", size: 14))
                                    .padding(.vertical, 10)
                                    .textContentType(.newPassword)
                                    .focused($focusedField, equals: .passwordFocus)
                                    .onSubmit{
                                        focusedField = nil
                                    }
                            } else {
                                SecureField("Password", text: $password)
                                    .font(.custom("Helvetica", size: 14))
                                    .padding(.vertical, 10)
                                    .textContentType(pageState == .login ? .password : .newPassword)
                                    .focused($focusedField, equals: .passwordFocus)
                                    .onSubmit{
                                        focusedField = nil
                                    }
                            }
     
                            Button(action: {
                                isPasswordVisible.toggle()
                            }){
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .renderingMode(.template)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 10)
                            }
                            
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius:5).stroke(Color.b700, lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        if(invalidPassword){
                            Text("Invalid Password")
                                .font(.footnote)
                                .foregroundStyle(Color.red)
                                .padding(.leading, 25)
                        }
                        
                        let isON = pageState  == .login
                        Text(isON ? "Forgot Password?" : "")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.t400)
                            .padding(EdgeInsets(top: 5, leading: 25, bottom: 30, trailing: 30))
                        
                        
                        // Login Button
                        let buttonText: String = if(pageState == .login){"Log in"} else {"Create Account"}
                        Button(action: {
                            Task {
                                isLoading = true
                                let isSuccessful = if pageState == .login{
                                    await loginViewModel.login(email: emailAddress, password: password){isSuccessful, statusCode in
                                        appState.isLoggedIn = isSuccessful
                                        invalidEmail = statusCode == 404
                                    }
                                } else {
                                    await loginViewModel.createAccount(email: emailAddress, password: password){isSuccessful, statusCode in
                                        appState.isLoggedIn = isSuccessful
                                    }
                                }
                                isLoading = false
                                if(appState.isLoggedIn){
                                    navController.currentScreen = .conversation
                                }
                                appState.userId = loginViewModel.currentUser?.id.uuidString ?? ""
                            }
                        }){
                            Capsule().fill(Color.b700)
                                .overlay(Text(buttonText))
                                .foregroundStyle(Color.t100)
                                .padding(.horizontal, 20)
                                .frame(height: 50)
                        }
                        
                        let swapPageText: String = if(pageState == .login){"Don't have an account?"} else {"Already have an account?"}
                        let swapPageButtonText: String = if(pageState == .login){"Sign up"} else {"Log in"}
                        
                        HStack(alignment: .center){
                            Spacer()
                            Text(swapPageText)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.t600)
                            Button(swapPageButtonText){
                                if(pageState == .login){
                                    pageState = .register
                                } else {
                                    pageState = .login
                                }
                                invalidEmail = false
                                invalidPassword = false
                                
                            }
                            .font(.system(size: 12))
                            .foregroundStyle(Color.b700)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 20))
                            Spacer()
                            
                        }
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20).fill(Color.t100))
                    .padding(.horizontal, 30)
                    .shadow(radius: 10)
                    
                    Spacer()
                }
                if(isLoading){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.b900))
                        .scaleEffect(2)
                }
            }
        }
    }
}

enum PageState: Hashable {
    case login
    case register
}
enum Focus: Hashable {
    case none
    case email
    case password
}



#Preview {
    LoginScreen()
}
