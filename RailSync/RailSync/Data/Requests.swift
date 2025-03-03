//
//  RequestDTOs.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import Foundation

struct UserRequestDTO: Codable {
    var Email: String
    var Password: String
}

struct LoginRequestDTO: Codable {
    var Email: String
    var Password: String
}

struct SpeakToAIRequestDTO: Codable {
    var UserID: UUID
    var ConversationID: UUID?
    var AIMessage: String
}
struct NewSpeakToAIRequestDTO: Codable {
    var UserID: UUID
    var AIMessage: String
}

struct AllConversationRequestDTO: Codable {
    var UserID: String
}

struct ConversationsRequestDTO: Codable {
    var ConversationID: String
    var UserID: String
}


