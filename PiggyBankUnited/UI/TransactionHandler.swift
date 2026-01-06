//
//  TransactionHandler.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/6/26.
//

import SwiftUI

struct TransactionHandler: View {
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

