//
//  AppState.swift
//  RailSync
//
//  Created by Conner Haar on 2/22/25.
//

import Foundation


class AppState: ObservableObject {
    
    static let shared = AppState()
    private let defaults = UserDefaults.standard
    
    init() {
        self.isLoggedIn = defaults.bool(forKey: "isLoggedIn")
        self.userId = defaults.string(forKey: "userId") ?? ""
        self.viewedConversationId = defaults.string(forKey: "viewedConversationId") ?? ""
    }
    
    @Published var isLoggedIn: Bool {
         didSet { defaults.set(isLoggedIn, forKey: "isLoggedIn") }
     }

    @Published var userId: String {
        didSet { defaults.set(userId, forKey: "userId") }
    }
    
    @Published var viewedConversationId: String {
        didSet { defaults.set(userId, forKey: "viewedConversationId") }
    }
    
    func clearUserData() {
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "viewedConversationId")
        self.isLoggedIn = false
        self.userId = ""
        self.viewedConversationId = ""
    }
    
    
    
}
