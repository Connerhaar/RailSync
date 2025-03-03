//
//  User.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import Foundation

struct User: Identifiable{
    var id = UUID()
    var email: String = ""
    var password: String = ""
    
    init(userID: UUID, email: String, password: String) {
        self.id = userID
        self.email = email
        self.password = password
    }
    
    init(dto: UserDTO) {
        self.id = dto.UserID
        self.email = dto.Email ?? ""
        self.password = dto.Password ?? ""
    }
}

struct UserDTO: Codable{
    let UserID: UUID
    let Email: String?
    let Password: String?
}
