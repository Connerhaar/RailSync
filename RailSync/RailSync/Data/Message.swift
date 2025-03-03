//
//  Message.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import Foundation

// Message
public struct Message: Identifiable {
    public var id = UUID()
    
    var role: String = ""
    var content: [MessageContent] = []
    
    init(role: String, content: [MessageContent]) {
        self.role = role
        self.content = content
    }
    
    
    init(dto: MessageDTO){
        self.role = dto.role
        self.content = dto.content.map{MessageContent(dto: $0)}
    }
    
    init(returnedMessage: String) {
        self.role = "assistant"
        self.content = [MessageContent(type: "text" , text: returnedMessage)]
    }
    init(sentMessage: String) {
        self.role = "user"
        self.content = [MessageContent(type: "text" , text: sentMessage)]
    }
}

public struct MessageDTO: Codable {
    var role: String = ""
    var content: [MessageContentDTO] = []
}

// Message Content
public struct MessageContent: Identifiable {
    public var id = UUID()
    var type: String = ""
    var text: String = ""
    
    init(type: String, text: String) {
        self.type = type
        self.text = text
    }
    
    init(dto: MessageContentDTO){
        self.type = dto.type
        self.text = dto.text
    }
    
}

public struct MessageContentDTO: Codable {
    var type: String = ""
    var text: String
}

public struct AiResponseDTO: Codable {
    var Response: String = ""
    var ConversationID: UUID
}

