//
//  ContentView.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI

struct ContentScreen: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var navController = NavController.shared
    @State private var dragOffset = CGSize.zero
    var body: some View {
        ZStack{
            VStack{
                switch NavController.shared.currentScreen {
                case .loading:
                    LoadingScreen()
                case .login:
                    LoginScreen()
                case .conversation:
                    ConversationScreen()
                }
            }
            if(navController.showSideMenu){
                SideMenuScreen()
            }
        }
    }
}



#Preview {
    ContentScreen()
}
