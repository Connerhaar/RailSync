//
//  userMessage.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct userMessage: View {
    @Binding var message: String
    var body: some View {
        
        HStack {
            Spacer()
            Text(message)
                .frame(alignment: .trailing)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.t200))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .trailing)
                .padding(.horizontal, 20)
        }
        
        
        
        
    }
}

struct aiMessage: View {
    @Binding var message: String
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

#Preview {
    userMessage(message: .constant("Hello World"))
    aiMessage(message: .constant("Super long tex that is actually insane and why is this so long probably because this will be a good exmple of what htings will look like"))
    userMessage(message: .constant("Super long tex that is actually insane and why is this so long probably because this will be a good exmple of what htings will look like"))
}
