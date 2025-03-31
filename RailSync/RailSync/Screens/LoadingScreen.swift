//
//  LoadingScreen.swift
//  RailSync
//
//  Created by Conner Haar on 3/24/25.
//

import SwiftUI

struct LoadingScreen: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var navController = NavController.shared
    
    @State var degreesRotating = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.t300, Color.t700],
                startPoint: .bottomTrailing,
                endPoint: .topLeading)
            .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Image("app_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 90, height: 90, alignment: .center)
                    .foregroundStyle(Color.b100)
                    .rotationEffect(.degrees(degreesRotating))
                    .onAppear {
                        withAnimation(.linear(duration: 1)
                            .speed(0.1).repeatForever(autoreverses: false)) {
                                degreesRotating = 360.0
                            }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if(appState.isLoggedIn){
                                navController.currentScreen = .conversation
                            } else {
                                navController.currentScreen = .login
                            }
                        }
                    }
                Spacer()
            }
        }
    }
}

#Preview {
    LoadingScreen()
}
