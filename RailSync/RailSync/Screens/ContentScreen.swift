//
//  ContentView.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI

struct ContentScreen: View {
    @ObservedObject var appState = AppState.shared
    @State private var showSideMenu: Bool = false
    @State private var dragOffset = CGSize.zero
    var body: some View {
        ZStack {
            if(!appState.isLoggedIn){
                LoginView()
            } else {
                ConversationView(showMenu: $showSideMenu)
                    .padding(.vertical, 40)
            }
            SideMenuView(showMenu: $showSideMenu, dragOffset: $dragOffset)
        }
    }
}



#Preview {
    ContentScreen()
}
