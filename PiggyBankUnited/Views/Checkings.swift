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
                BannerView(firebaseAuthManager: firebaseAuthManager, color: .blue, userAccount: "Checkings")

                
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
                    CustomTextField(firebaseAuthManager: firebaseAuthManager, userAccount: "Checkings")
                    
                    
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Checkings")
            .toolbarColorScheme(.dark)
        }
    }
}



//TODO: see how you can optimize the code

//TODO: Improve UI
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
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    let userAccount: String
    
    
    enum TransactionSection: String, CaseIterable {
        case deposit = "Deposit"
        case withdraw = "Withdraw"
        
        var icon: String {
            switch self {
            case .deposit:
                return "plus.circle.fill"
                
            case .withdraw:
                return "minus.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .deposit:
                return .green
            case .withdraw:
                return .red
            }
        }
        
        
    }
    @State var segmentationSelection: TransactionSection = .deposit
    @State private var amount: String = ""
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            //segmentation selection
            Picker("", selection: $segmentationSelection) {
                ForEach(TransactionSection.allCases, id: \.self) {option in
                    //displays segments such as Deposit and Withdraw
                    Text(
                        option.rawValue
                    )
                    
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            

            //textfield
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
            
            Button(segmentationSelection.rawValue) {
                
                Task {
                    if(segmentationSelection.rawValue == "Deposit") {
                        await firebaseAuthManager.depositAmount(amount: Double(amount) ?? 0.0, account: userAccount)
                    }
                    else {
                        await firebaseAuthManager.withdrawAmount(amount: Double(amount) ?? 0.0, account: userAccount)
                    }
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(segmentationSelection.color)
            .clipShape(Capsule(style: .continuous))
        }
        
    }
    
}



#Preview {
    CheckingsView(firebaseAuthManager: .preview)
}
