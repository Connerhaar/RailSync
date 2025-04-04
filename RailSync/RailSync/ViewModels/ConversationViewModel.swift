//
//  ConversationViewModel.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import SwiftUI
import Combine

@MainActor
class ConversationViewModel: ObservableObject{
    @Published var allConversations: [Conversation] = []
    @Published var viewedConversation: [Message] = []
    @Published var aiTyping: Bool = false
    
    private init() {}

    static let shared = ConversationViewModel()
    
    
    func getAllConversations(userId: String) async {
            do {
                let requestBody: AllConversationRequestDTO = AllConversationRequestDTO(UserID: userId)
                let dto: [ConversationDTO] = try await NetworkManager.shared.request(endpoint: "/GetAllConversations", requestType: RequestType.POST, body: requestBody)
                allConversations = dto.map({Conversation(dto: $0)})
            } catch { handleError(error) }
    }
    
    func getConversation(userId: String, conversationId: String) async {
            do {
                let requestBody: ConversationsRequestDTO = ConversationsRequestDTO(ConversationID: conversationId, UserID: userId)
                let dto: [MessageDTO] = try await NetworkManager.shared.request(endpoint: "/GetAIConversation", requestType: RequestType.POST, body: requestBody)
                viewedConversation = dto.map({Message(dto: $0)})
            } catch { handleError(error) }
    }
    
    func sendMessage(userId: String, conversationId: String?, message: String) async {
        do {
            let sentMessage: Message = Message(sentMessage: message)
            self.viewedConversation.append(sentMessage)
            aiTyping = true
            let requestBody: Encodable = if(conversationId == nil){
                NewSpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, AIMessage: message)
            } else {
                SpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, ConversationID: UUID(uuidString: conversationId!)!, AIMessage: message)
            }
            print("request: \(requestBody)")
            let dto: AiResponseDTO = try await NetworkManager.shared.request(endpoint: "/SpeakToAI", requestType: RequestType.POST, body: requestBody)
            print("response: \(dto)")
            let responseMessage = Message(returnedMessage: dto.Response)
            aiTyping = false
//            AppState.shared.viewedConversationId = dto.ConversationID.uuidString
            viewedConversation.append(responseMessage)
        } catch {
            aiTyping = false
            print(error)
            handleError(error) }
    }
    
    func sendMessageToFRAModel(userId: String, conversationId: String?, message: String) async {
        do {
            let sentMessage: Message = Message(sentMessage: message)
            self.viewedConversation.append(sentMessage)
            let requestBody: Encodable = if(conversationId == nil){
                NewSpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, AIMessage: message)
            } else {
                SpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, ConversationID: UUID(uuidString: conversationId!)!, AIMessage: message)
            }
            print("request: \(requestBody)")
            let dto: AiResponseDTO = try await NetworkManager.shared.request(endpoint: "/FRARegulations", requestType: RequestType.POST, body: requestBody)
            print("response: \(dto)")
            let responseMessage = Message(returnedMessage: dto.Response)
//            AppState.shared.viewedConversationId = dto.ConversationID.uuidString
            viewedConversation.append(responseMessage)
        } catch {
            print(error)
            handleError(error) }
    }
    
    func sendMessageToSixtyModel(userId: String, conversationId: String?, message: String) async {
        do {
            let sentMessage: Message = Message(sentMessage: message)
            self.viewedConversation.append(sentMessage)
            let requestBody: Encodable = if(conversationId == nil){
                NewSpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, AIMessage: message)
            } else {
                SpeakToAIRequestDTO(UserID: UUID(uuidString: userId)!, ConversationID: UUID(uuidString: conversationId!)!, AIMessage: message)
            }
            print("request: \(requestBody)")
            let dto: AiResponseDTO = try await NetworkManager.shared.request(endpoint: "/SpeakAbouts-60", requestType: RequestType.POST, body: requestBody)
            print("response: \(dto)")
            let responseMessage = Message(returnedMessage: dto.Response)
//            AppState.shared.viewedConversationId = dto.ConversationID.uuidString
            viewedConversation.append(responseMessage)
        } catch {
            print(error)
            handleError(error) }
    }
    
    func deleteConversation(userId: String, conversationId: String) async{
        do {
            viewedConversation = []
            allConversations.removeAll{ $0.id == conversationId }
            let conversationDeletionDTO = DeleteConversationDTO(UserID: userId, ConversationID: conversationId)
            try await NetworkManager.shared.request(endpoint: "/DeleteConversation", requestType: RequestType.POST, body: conversationDeletionDTO)
        } catch {
            handleError(error)
        }
    }
    
}

