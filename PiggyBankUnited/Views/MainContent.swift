//
//  MainContent.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/2/26.
//

import SwiftUI

struct MainContentView: View {
    @Binding var showMainContent: Bool
    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            SettingsView(firebaseAuthManager: FirebaseAuthManager())
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


#Preview {
    MainContentView(showMainContent: .constant(true))
}
