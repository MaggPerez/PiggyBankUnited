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
    DashboardView(firebaseAuthManager: .preview)
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





