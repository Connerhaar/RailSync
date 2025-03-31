//
//  ChatView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct ConversationScreen: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var navController = NavController.shared
    
    @StateObject private var conversationViewModel = ConversationViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var title: String = "RailSync"
    @State var userInput: String = ""
    
    var body: some View {
        ZStack {
            Color.b100.ignoresSafeArea()

            VStack {
                // Top Bar
                HStack {
                    Button(action: {
                        navController.showSideMenu = true
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .foregroundStyle(Color.t700)
                    }
                    Spacer()
                    Text(AppState.shared.viewedConversation?.conversationName ?? "RailSync")
                    Spacer()
                    Menu {
                        Button{
                            appState.viewedConversation = nil
                            
                        } label: {
                            Label("New Conversation", systemImage: "plus")
                        }
                        
                        if (appState.viewedConversation != nil){
                            Button(role: .destructive){
                                Task{
                                    let conversationId: String = appState.viewedConversation!.id
                                    appState.viewedConversation = nil
                                    await conversationViewModel.deleteConversation(userId: appState.userId, conversationId: conversationId)
                                }
                            } label: {
                                Label("Delete Conversation", systemImage: "minus")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .foregroundStyle(Color.t700)
                    }
                    }
                Divider()

                // Messages
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(conversationViewModel.viewedConversation.indices, id: \.self) { index in
                                messageView(for: conversationViewModel.viewedConversation[index])
                                    .id(index) // Assign a unique ID for scrolling
                            }
                            if conversationViewModel.aiTyping {
                                TypingIndicatorView()
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: .infinity)
                    .onChange(of: conversationViewModel.viewedConversation.count) {
                        // Auto-scroll to the latest message
                        withAnimation {
                            scrollView.scrollTo(conversationViewModel.viewedConversation.count - 1, anchor: .bottom)
                        }
                    }
                }
                // TextField at the Bottom
                    HStack {
                        TextField("Ask a question", text: $userInput)
                            .font(.custom("Helvetica", size: 18))
                            .foregroundStyle(.black)
                            .focused($isTextFieldFocused)
                            .padding(.horizontal)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrowshape.up.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .foregroundStyle(Color.blue)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.t100)
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    .ignoresSafeArea(.all)
                    .adaptsToKeyboard()

            }
            .padding(.top, 50)
            .padding(.bottom, 25)
            .onTapGesture {
                isTextFieldFocused = false
            }
            .onChange(of: AppState.shared.viewedConversation) {
                conversationViewModel.viewedConversation = AppState.shared.viewedConversation?.messages ?? []
            }
        }
        .ignoresSafeArea()
    }
    
    func sendMessage() {
        Task {
            let message = userInput
            userInput = ""
            if(message != ""){
                await conversationViewModel.sendMessage(userId: appState.userId, conversationId: AppState.shared.viewedConversation?.id, message: message)
            }
            isTextFieldFocused = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
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
    ConversationScreen()
}
