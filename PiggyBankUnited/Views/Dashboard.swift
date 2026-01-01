//
//  Dashboard.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/1/26.
//

import SwiftUI

struct DashboardView: View {
    @Binding var showDashboard: Bool
    @ObservedObject var firebaseManager = FirebaseAuthManager()
    
    var body: some View {
        NavigationStack{
            Button("Sign Out"){
                firebaseManager.signOut()
            }
            .navigationTitle("Dashboard")
            .navigationSubtitle("Here are your stats")
            
        }
        
        
        
    }
}

#Preview {
    DashboardView(showDashboard: .constant(true))
}

