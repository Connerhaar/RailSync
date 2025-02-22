//
//  Message.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import Foundation

public struct Message: Hashable {
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
}

public struct Item: Decodable {
    var Item: ConversationData
}

public struct ConversationData: Decodable{
    var ConversationID: UUID
    var UserID: UUID
    var Messages: String

}

public struct MessageDTO: Decodable {
    var role: String = ""
    var content: [MessageContentDTO] = []
}




public struct MessageContent: Hashable {
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

public struct MessageContentDTO: Decodable {
    var type: String = ""
    var text: String
}

public struct Data: Encodable {
    
}
