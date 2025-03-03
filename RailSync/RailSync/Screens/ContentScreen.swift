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
                LoginScreen()
            } else {
                ConversationScreen(showMenu: $showSideMenu).ignoresSafeArea(.keyboard)
            }
            SideMenuScreen(showMenu: $showSideMenu, dragOffset: $dragOffset).ignoresSafeArea(.keyboard)
        }.ignoresSafeArea(.keyboard)
    }
}



#Preview {
    ContentScreen()
}
