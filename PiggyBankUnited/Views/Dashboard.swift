//
//  Dashboard.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/1/26.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager

    var body: some View {
        NavigationStack{
            VStack {
                Text("Welcome User")
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView(firebaseAuthManager: FirebaseAuthManager())
}







