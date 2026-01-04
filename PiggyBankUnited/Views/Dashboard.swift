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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Welcome message
                    Text("Welcome, \(username)!")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)

                    // Account cards grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        //checkings
                        
                        NavigationLink(destination: CheckingsView(firebaseAuthManager: firebaseAuthManager)){
                            CardsView(
                                title: "Checkings",
                                description: "View your checking account",
                                color: .blue,
                                icon: "dollarsign.circle.fill"
                            )
                        }

                        NavigationLink(destination: SavingsView()){
                            //savings
                            CardsView(
                                title: "Savings",
                                description: "Track your savings",
                                color: .green,
                                icon: "banknote.fill"
                            )
                        }

                        //cd
                        CardsView(
                            title: "CD Account",
                            description: "Certificate of Deposit",
                            color: .purple,
                            icon: "chart.line.uptrend.xyaxis"
                        )

                        //statements
                        CardsView(
                            title: "Statements",
                            description: "View statements",
                            color: .orange,
                            icon: "doc.text.fill"
                        )

                        //transfers
                        CardsView(
                            title: "Transfers",
                            description: "Move your money",
                            color: .teal,
                            icon: "arrow.left.arrow.right"
                        )

                        //investments
                        CardsView(
                            title: "Investments",
                            description: "Portfolio overview",
                            color: .indigo,
                            icon: "chart.pie.fill"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView(firebaseAuthManager: .preview)
}

struct CardsView: View {
    let title: String
    let description: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon at the top
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)

            Spacer()

            // Title and description at the bottom
            VStack(alignment: .leading, spacing: 4) {
                
                // title
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // description
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        // alignments inside the cards
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}


/**
 function to trim email domain
 */
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





