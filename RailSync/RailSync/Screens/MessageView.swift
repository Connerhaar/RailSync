//
//  ChatView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct MessageView: View {
    @Binding var showMenu: Bool
    @StateObject private var messageViewModel = MessageViewModel()
    var body: some View {
        ZStack {
            Color.b200
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
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
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach($messageViewModel.messages, id: \.self) { messageInfo in
                            if(messageInfo.role.wrappedValue == "assistant"){
                                ForEach(messageInfo.content, id: \.self){ message in
                                    if(message.type.wrappedValue == "text"){
                                        aiMessage(message: message.text)
                                    }
                                }
                                
                            } else {
                                ForEach(messageInfo.content, id: \.self){ message in
                                    if(message.type.wrappedValue == "text"){
                                        userMessage(message: message.text)
                                    }
                                }
                            }
                        }
                    }
                }
            }
   
        }
        .onAppear{
            Task {
                messageViewModel.getMessages()
            }
        }
    }
}

#Preview {
    MessageView(showMenu: .constant(false))
}
