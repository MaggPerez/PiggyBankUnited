//
//  CD.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 2/2/26.
//

import SwiftUI

struct CDView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                BannerView(firebaseAuthManager: firebaseAuthManager, color: .purple, userAccount: "CD")
                
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
                    
                    
                    TransactionHandler(firebaseAuthManager: firebaseAuthManager, userAccount: "CD")
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("CD")
            .toolbarColorScheme(.dark)
        }
        
    }
}


#Preview {
    CDView(firebaseAuthManager: .preview)
}
