//
//  ContentView.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var loggedIn: Bool = false
    @State private var showSideMenu: Bool = false
    @State private var dragOffset = CGSize.zero
    var body: some View {
        ZStack {
            if(!loggedIn){
                withAnimation {
                    LoginView(loggedIn: $loggedIn)
                }
            } else {
                withAnimation {
                    MessageView(showMenu: $showSideMenu)
                }
            }
            
            SideMenuView(showMenu: $showSideMenu, dragOffset: $dragOffset)
        }
    }
}



#Preview {
    ContentView()
}
