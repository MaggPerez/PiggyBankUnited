//
//  Checkings.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/3/26.
//

import SwiftUI

struct CheckingsView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                //banner
                BannerView()

                
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
                    CustomTextField()
                    
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Checkings")
            .toolbarColorScheme(.dark)
        }
    }
}


struct BannerView: View {
    var body: some View {
        VStack(spacing: 8){
            
            Text("$0")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                
            
            Text("Available Balance")
                .foregroundColor(.white)
                .bold()
            
            
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.blue)
        
        
    }
}

struct OptionsView: View {
    let itemName: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
            
            Text(itemName)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        
    }
}


struct CustomTextField: View {
    @State private var amount: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter amount", text: $amount)
                .keyboardType(.numberPad)
                .padding(.vertical)
                .padding(.horizontal, 24)
                .background(
                    Color(UIColor.systemGray6)
                )
                .clipShape(Capsule(style: .continuous))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.black, lineWidth: 0.1)
                )
                    
                
            
            //filtering non-digit chars
                .onChange(of: amount) { oldValue, newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        self.amount = filtered
                    }
                }
        }
        
    }
}


#Preview {
    CheckingsView(firebaseAuthManager: .preview)
}
