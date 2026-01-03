//
//  Profile.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/2/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Profile")
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(firebaseAuthManager: .preview)
}
