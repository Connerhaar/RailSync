//
//  SideMenuView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct SideMenuScreen: View {
    @ObservedObject var conversationViewModel = ConversationViewModel.shared
    @ObservedObject var navController = NavController.shared
    

//    @Binding var dragOffset: CGSize // Track the drag offset
    private let menuWidth = UIScreen.main.bounds.width * 0.8 // 80% of screen width

    var body: some View {
        ZStack {
            // Background overlay to dismiss menu when tapped
            if(navController.showSideMenu) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            navController.showSideMenu = false
                        }
                    }
            }

            HStack {
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                    Text("Conversations")
                                        .font(.headline)
                                        .foregroundStyle(.t800)
                                        .fontWeight(.bold)
                                    Divider()
                                ScrollView(showsIndicators: false){
                                        LazyVStack{
                                            ForEach(conversationViewModel.allConversations){ conversation in
                                                HStack{
                                                    Text(conversation.conversationName)
                                                        .font(.system(size: 14))
                                                        .padding(.vertical, 5)
                                                        .padding(.leading, 10)
                                                        .fontWeight(.medium)
                                                        .lineLimit(1)
                                                        .onTapGesture{
                                                            AppState.shared.viewedConversation = conversation
                                                            navController.showSideMenu = false
                                                        }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }.frame(maxHeight: .infinity)
                                Divider()
                                Spacer(minLength: 15)
                                Button {
                                    AppState.shared.isLoggedIn = false
                                    navController.showSideMenu = false
                                    navController.currentScreen = .login
                                } label: {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                                            .foregroundStyle(.t800)
                                        Text("Sign Out")
                                            .foregroundStyle(.t800)
                                    }
                                    .foregroundStyle(Color.black)
                                    .padding(.bottom, 30)
                                }
                            }.padding(.vertical, 30)
                        }
                        
                    }
                    .padding()
                    .frame(width: menuWidth, height: UIScreen.main.bounds.height) // Dynamic width
                    .background(Color.white)
                    //                .offset(x: navController.showSideMenu ? dragOffset.width : -menuWidth) // Slide with the gesture
                    .animation(.easeInOut(duration: 0.3), value: navController.showSideMenu) // Smooth transition
                    
                    if(conversationViewModel.allConversationsLoading){
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.b900))
                            .scaleEffect(1.5)
                    }
                    VStack{
                        HStack{
                            if(!conversationViewModel.allConversationsLoading && conversationViewModel.allConversations.isEmpty){
                                Text("No Conversations")
                                    .foregroundStyle(.t500)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SideMenuScreen()
}
