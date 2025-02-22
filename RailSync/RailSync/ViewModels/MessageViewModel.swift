//
//  MessageViewModel.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//
import SwiftUI
import Combine

@MainActor
final class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    func getMessages() {
        Task {
            do {
                let dto: [MessageDTO] = try await NetworkManager.shared.request(endpoint: "/GetAIConversation", requestType: RequestType.GET)
                messages = dto.map({Message(dto: $0)})
            } catch { handleError(error) }

        }
        
//        NetworkManager.shared.request(
//            url: "https://ryzue2aool.execute-api.us-east-1.amazonaws.com/default/GetAIConversation",
//            type: "GET",
//            returnType: Item.self){ result in
//            switch result {
//            case .success(let data):
//                let jsonData = data.Item.Messages.data(using: .utf8)
//                let dto = try? JSONDecoder().decode([MessageDTO].self, from: jsonData!)
//                if let dto = dto {
//                    DispatchQueue.main.async{[weak self] in
//                        self?.messages = dto.map({Message(dto: $0)})
//                    }
//                }
//                print("success network: \(data)")
//            case .failure(let failure):
//                print("failed network: \(failure)")
//            }
//        }
    }
    
}
