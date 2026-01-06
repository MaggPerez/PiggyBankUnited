//
//  Savings.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/3/26.
//

import SwiftUI

struct SavingsView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                //banner
                BannerView(firebaseAuthManager: firebaseAuthManager, color: .green, userAccount: "Savings")

                
                //options
                VStack(spacing: 40) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        OptionsView(itemName: "Transfer", icon: "arrow.left.arrow.right")
                        OptionsView(itemName: "Pay Bills", icon: "creditcard")
                        OptionsView(itemName: "Deposit", icon: "camera")
                        OptionsView(itemName: "ATM Locator", icon: "location")
                        OptionsView(itemName: "Statements", icon: "doc.text")
                        OptionsView(itemName: "Settings", icon: "gearshape")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    )
                    
                    
                    //textfields to deposit and withdraw
                    CustomTextField(firebaseAuthManager: firebaseAuthManager, userAccount: "Savings")
                    
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Savings")
            .toolbarColorScheme(.dark)
        }
    }
}


#Preview {
    SavingsView(firebaseAuthManager: .preview)
}
