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
        let username = trimEmailDomain(email: firebaseAuthManager.getUserEmail() ?? "Guest")
        NavigationStack{
            VStack {
                Text("Welcome \(username)")
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    // Create a mock FirebaseAuthManager for preview
    class MockFirebaseAuthManager: FirebaseAuthManager {
        let username = ""
        let sampleEmail = "preview@gmail.com"
        override func getUserEmail() -> String? {
            return trimEmailDomain(email: sampleEmail)
        }
        
        override init() {
            super.init()
            self.isAuthenticated = true
        }
    }
    
    return DashboardView(firebaseAuthManager: MockFirebaseAuthManager())
}

func trimEmailDomain(email: String) -> String {
    //split email address by the @ symbol
    let components = email.split(separator: "@")
    
    //first element in the components array is the username (before "@"
    //converting substring result into a String
    if let username = components.first {
        return String(username)
    }
    else {
        //return the original email if no @ symbol is found
        return email
    }
}





