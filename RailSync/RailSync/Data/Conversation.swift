//
//  Conversation.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import Foundation

struct Conversation {
    var userId: UUID
    var conversationId: String
    var conversationName: String
    var lasUpdated: Date
    var messages: [Message]
    
    init (dto: ConversationDTO){
        self.userId = UUID(uuidString: dto.UserID) ?? UUID()
        self.conversationId = dto.ConversationID
        self.conversationName = dto.ConversationName
        self.lasUpdated = dto.LastUpdated
        self.messages = dto.Messages.map{Message(dto: $0)}
    }
}

struct ConversationDTO: Codable {
    var UserID: String
    var ConversationID: String
    var ConversationName: String
    var LastUpdated: Date
    var Messages: [MessageDTO]
}


