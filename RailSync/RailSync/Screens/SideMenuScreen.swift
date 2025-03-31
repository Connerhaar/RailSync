//
//  SideMenuView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct SideMenuScreen: View {
    @StateObject private var conversationViewModel = ConversationViewModel()
    @ObservedObject var navController = NavController.shared
    

//    @Binding var dragOffset: CGSize // Track the drag offset
    private let menuWidth = UIScreen.main.bounds.width * 0.8 // 80% of screen width

    var body: some View {
        ZStack(alignment: .bottom) {
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
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer(minLength: 10)
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading){
                                Text("Conversations")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                ScrollView{
                                    LazyVStack{
                                        ForEach(conversationViewModel.allConversations){ conversation in
                                            HStack{
                                                    Text(conversation.conversationName)
                                                        .font(.system(size: 14))
                                                        .padding(.vertical, 5)
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
                                }
                            }.padding(.vertical, 30)
                            
                            Button {
                                AppState.shared.isLoggedIn = false
                                navController.showSideMenu = false
                                navController.currentScreen = .login
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    Text("Sign Out")
                                }
                                .foregroundStyle(Color.black)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    
                }
                .padding()
                .frame(width: menuWidth, height: UIScreen.main.bounds.height) // Dynamic width
                .background(Color.white)
//                .offset(x: navController.showSideMenu ? dragOffset.width : -menuWidth) // Slide with the gesture
                .animation(.easeInOut(duration: 0.3), value: navController.showSideMenu) // Smooth transition
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            // Allow dragging only if menu is open or the user is opening it
//                            if navController.showSideMenu && (menuWidth + value.translation.width < menuWidth){
//                                dragOffset = value.translation
//                            }
//     
//                        }
//                        .onEnded { value in
//                            withAnimation {
//                                // Close the menu if drag is not far enough
//                                if dragOffset.width + menuWidth < UIScreen.main.bounds.width * 0.5 {
//                                    withAnimation {
//                                        navController.showSideMenu = false
//                                    }
//                                } else {
//                                    withAnimation{navController.showSideMenu = true}
//                                }
//                                // Delay resetting dragOffset to avoid a visual snap
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    dragOffset = .zero
//                                }
//
//                            }
//                        }
//                )
                Spacer()
            }
        }.onAppear(){
            Task{
                await conversationViewModel.getAllConversations(userId: AppState.shared.userId)
            }
        }
    }
}

#Preview {
    SideMenuScreen()
}
