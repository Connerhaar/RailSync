//
//  ChatView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct ConversationScreen: View {
    @ObservedObject var appState = AppState.shared
    
    @StateObject private var conversationViewModel = ConversationViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    @Binding var showMenu: Bool
    @State var userInput: String = ""
    
    var body: some View {
        ZStack {
            Color.b100
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                ZStack {
                    HStack{
                        Button(action: {
                            showMenu = true
                        }){
                            Image(systemName: "gear")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 25))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("RailSync")
                        Spacer()
                    }
                }
                Spacer()
                ScrollView {
                    LazyVStack {
                        ForEach(conversationViewModel.viewedConversation) { message in
                            messageView(for: message)
                        }
                    }
                    Spacer()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .ignoresSafeArea(.all)
                        .frame(height: 80)
                        .foregroundStyle(.t100)
                        .shadow(radius: 5)
                    
                    TextField("Ask a question", text: $userInput)
                        .font(.custom("Helvetica", size: 18))
                        .foregroundStyle(.black)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .onSubmit {
                            Task {
                                await conversationViewModel.sendMessage(userId: appState.userId, conversationId: nil, message: userInput)
                                userInput = ""
                            }
                        }
                }
                .padding(.bottom, keyboardResponder.keyboardHeight)
                .animation(.easeOut(duration: 0.3), value: keyboardResponder.keyboardHeight)
                
            }
            .onAppear{
                Task {
                    await conversationViewModel.getConversation(userId: appState.userId, conversationId: appState.viewedConversationId)
                }
            }
        }
    }
    // Separate method to break down complex expressions
    @ViewBuilder
    private func messageView(for message: Message) -> some View {
        if message.role == "assistant" {
            assistantMessages(for: message.content)
        } else {
            userMessages(for: message.content)
        }
    }
    
    @ViewBuilder
    private func assistantMessages(for contents: [MessageContent]) -> some View {
        ForEach(contents) { content in
            if content.type == "text" {
                aiMessage(message: content.text)
            }
        }
    }
    
    @ViewBuilder
    private func userMessages(for contents: [MessageContent]) -> some View {
        ForEach(contents) { content in
            if content.type == "text" {
                userMessage(message: content.text)
            }
        }
    }
}

#Preview {
    ConversationScreen(showMenu: .constant(false))
}
