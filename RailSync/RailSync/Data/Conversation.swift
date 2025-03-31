//
//  Conversation.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import Foundation

struct Conversation: Identifiable, Equatable, Codable {
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.userId != rhs.userId {
            return false
        }
        if lhs.conversationName != rhs.conversationName {
            return false
        }
        return true
    }
    
    var id: String
    var userId: UUID
    var conversationName: String
    var lasUpdated: String
    var messages: [Message]
    
    init (dto: ConversationDTO){
        self.id = dto.ConversationID
        self.userId = UUID(uuidString: dto.UserID) ?? UUID()
        self.conversationName = dto.ConversationName
        self.lasUpdated = dto.LastUpdated
        self.messages = dto.Messages.map{Message(dto: $0)}
    }
}

struct ConversationDTO: Codable {
    var UserID: String
    var ConversationID: String
    var ConversationName: String
    var LastUpdated: String
    var Messages: [MessageDTO]
}

struct DeleteConversationDTO: Codable {
    var UserID: String
    var ConversationID: String
}


