//
//  LoginView.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI



struct LoginScreen: View {
    @ObservedObject var appState = AppState.shared
    @StateObject private var loginViewModel = LoginViewModel()
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var pageState: PageState = .login
   
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [Color.t300, Color.t700],
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading)
                .edgesIgnoringSafeArea(.all)
                
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
                                .renderingMode(.original)
                                .resizable()
                                .foregroundStyle(Color.b800)
                                .frame(width: 20, height: 15)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                            
                            
                            TextField("Email Address", text: $emailAddress)
                                .font(.custom("Helvetica", size: 14))
                                .padding(.vertical, 10)
                                .textContentType(.emailAddress)
                        }
                        .overlay(RoundedRectangle(cornerRadius:5).stroke(Color.b700, lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Password TextField
                        HStack(alignment: .center){
                            Image(systemName: "lock")
                                .renderingMode(.original)
                                .resizable()
                                .foregroundStyle(Color.b800)
                                .frame(width: 15, height: 20)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                            
                            TextField("Password", text: $password)
                                .font(.custom("Helvetica", size: 14))
                                .padding(.vertical, 10)
                                .textContentType(.newPassword)
                            
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius:5).stroke(Color.b700, lineWidth: 1))
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        let isON = pageState  == .login
                        Text(isON ? "Forgot Password?" : "")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.t400)
                            .padding(EdgeInsets(top: 5, leading: 25, bottom: 30, trailing: 30))
                        
                        
                        // Login Button
                        let buttonText: String = if(pageState == .login){"Log in"} else {"Create Account"}
                        Button(action: {
                            Task {
                                let isSuccessful = if pageState == .login{
                                    await loginViewModel.login(email: emailAddress, password: password){_ in }
                                } else {
                                    await loginViewModel.createAccount(email: emailAddress, password: password){_ in }
                                }
                                await MainActor.run{
                                    appState.isLoggedIn = isSuccessful
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
