//
//  BottomNavBar.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/1/26.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager

    var body: some View {
        NavigationStack {
            VStack {
                Button("Sign Out") {
                    firebaseAuthManager.signOut()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(firebaseAuthManager: .preview)
}

