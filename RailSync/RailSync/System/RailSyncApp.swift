//
//  RailSyncApp.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//

import SwiftUI

@main
struct RailSyncApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentScreen()
                .environmentObject(appState)
        }
    }
}
