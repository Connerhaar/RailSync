//
//  RequestDTOs.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import Foundation

public struct UserRequestDTO: Codable {
    var Email: String
    var Password: String
}

public struct LoginRequestDTO: Codable {
    var Email: String
    var Password: String
}

public struct SpeakToAIRequestDTO: Codable {
    var UserID: UUID
    var ConversationID: UUID
    var AIMessage: String
}

public struct AllConversationRequestDTO: Codable {
    var UserID: String
}

public struct ConversationsRequestDTO: Codable {
    var ConversationID: String
    var UserID: String
}


