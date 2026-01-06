//
//  Banner.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/6/26.
//

import SwiftUI

struct BannerView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    @State private var balance: Double = 0.0
    @State private var isLoading: Bool = false
    
    let color: Color
    let userAccount: String
    
    var body: some View {
        VStack(spacing: 8){
            
            
            //loading
            if isLoading {
                Text("Loading")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            }
            else {
                //user's balance
                Text("$\(String(format: "%.2f", firebaseAuthManager.currentBalance))")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            }
                
            //available balance
            Text("Available Balance")
                .foregroundColor(.white)
                .bold()
            
            
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(color)
        .task {
            await firebaseAuthManager.getUserBalance(account: userAccount)
        }

    }
}

#Preview {
    BannerView(firebaseAuthManager: .preview, color: .blue, userAccount: "Checkings")
}
