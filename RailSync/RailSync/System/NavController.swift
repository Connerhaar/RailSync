//
//  NavController.swift
//  RailSync
//
//  Created by Conner Haar on 3/24/25.
//

import SwiftUI

class NavController: ObservableObject {
    static let shared = NavController()
    
    enum Screen {
        case loading, login, conversation
    }
    
    @Published var currentScreen: Screen = .loading
    @Published var showSideMenu: Bool = false
}
