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
        
        // Remove the stored conversation every time the app launches
        defaults.removeObject(forKey: "viewedConversation")
        self.viewedConversation = nil
    }
    
    @Published var isLoggedIn: Bool {
         didSet { defaults.set(isLoggedIn, forKey: "isLoggedIn") }
     }

    @Published var userId: String {
        didSet { defaults.set(userId, forKey: "userId") }
    }
    
    @Published var viewedConversation: Conversation? {
        didSet {
            if let conversation = viewedConversation {
                if let encodedData = try? JSONEncoder().encode(conversation) {
                    defaults.set(encodedData, forKey: "viewedConversation")
                }
            } else {
                defaults.removeObject(forKey: "viewedConversation")
            }
        }
    }
    
    
    func clearUserData() {
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "viewedConversation")
        self.isLoggedIn = false
        self.userId = ""
        self.viewedConversation = nil
    }
    
    
    
}
