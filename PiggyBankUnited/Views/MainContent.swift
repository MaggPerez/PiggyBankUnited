//
//  MainContent.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/2/26.
//

import SwiftUI

struct MainContentView: View {
    @Binding var showMainContent: Bool
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager

    var body: some View {
        TabView {
            DashboardView(firebaseAuthManager: firebaseAuthManager)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            ProfileView(firebaseAuthManager: firebaseAuthManager)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }

            SettingsView(firebaseAuthManager: firebaseAuthManager)
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


#Preview {
    MainContentView(showMainContent: .constant(true), firebaseAuthManager: .preview)
}
