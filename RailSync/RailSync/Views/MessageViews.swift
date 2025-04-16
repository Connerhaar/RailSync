//
//  userMessage.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct userMessage: View {
    @State var message: String
    var body: some View {
        
        HStack {
            Spacer()
            Text(message)
                .frame(alignment: .trailing)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.b200))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .trailing)
                .padding(.horizontal, 20)
        }
        
        
        
        
    }
}

struct aiMessage: View {
    @State var message: String
    var body: some View {
        
        HStack {
            Text(message)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.leading, 20)
            Spacer()
        }
    }
}


struct TypingIndicatorView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack{
            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                        .opacity(isAnimating ? 0.2 : 1)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever()
                                .delay(Double(index) * 0.3),
                            value: isAnimating
                        )
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 15)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(40)
            .onAppear {
                isAnimating = true
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            Spacer()
        }
        
    }
}

#Preview {
    userMessage(message: "Hello World")
    aiMessage(message: "Super long tex that is actually insane and why is this so long probably because this will be a good exmple of what htings will look like")
    userMessage(message: "Super long tex that is actually insane and why is this so long probably because this will be a good exmple of what htings will look like")
    TypingIndicatorView()
}
