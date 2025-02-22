//
//  SideMenuView.swift
//  RailSync
//
//  Created by Conner Haar on 2/13/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var showMenu: Bool
    @Binding var dragOffset: CGSize // Track the drag offset
    private let menuWidth = UIScreen.main.bounds.width * 0.8 // 80% of screen width

    var body: some View {
        ZStack {
            // Background overlay to dismiss menu when tapped
            if(showMenu) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
            }

            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("Welcome, User")
                            .font(.headline)
                    }
                    .padding(.top, 40)

                    NavigationLink(destination: Text("Home View")) {
                        Label("Home", systemImage: "house")
                    }

                    NavigationLink(destination: Text("Profile View")) {
                        Label("Profile", systemImage: "person")
                    }

                    NavigationLink(destination: Text("Settings View")) {
                        Label("Settings", systemImage: "gear")
                    }

                    Spacer()
                }
                .padding()
                .frame(width: menuWidth, height: UIScreen.main.bounds.height) // Dynamic width
                .background(Color.white)
                .offset(x: showMenu ? dragOffset.width : -menuWidth) // Slide with the gesture
                .animation(.easeInOut(duration: 0.3), value: showMenu) // Smooth transition
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Allow dragging only if menu is open or the user is opening it
                            if showMenu && (menuWidth + value.translation.width < menuWidth){
                                dragOffset = value.translation
                            }
     
                        }
                        .onEnded { value in
                            withAnimation {
                                // Close the menu if drag is not far enough
                                if dragOffset.width + menuWidth < UIScreen.main.bounds.width * 0.5 {
                                    withAnimation {
                                        showMenu = false
                                    }
                                } else {
                                    withAnimation{showMenu = true}
                                }
                                // Delay resetting dragOffset to avoid a visual snap
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dragOffset = .zero
                                }

                            }
                        }
                )
                Spacer()
            }
        }
    }
}

#Preview {
    SideMenuView(showMenu: .constant(true), dragOffset: .constant(CGSize()))
}
