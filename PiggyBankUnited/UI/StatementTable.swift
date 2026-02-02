//
//  StatementTable.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 2/2/26.
//

import SwiftUI
import Foundation

struct Statement: Identifiable {
    let id = UUID()
    let account: String
    let amount: Double
    let transaction: TransactionType
    let availableBalance: Double
    let date: Date
}

enum TransactionType: String, CaseIterable {
    case deposit = "Deposit"
    case withdrawal = "Withdrawal"
}



struct StatementRowView: View {
    let statement: Statement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading) {
                    Text(statement.account)
                        .font(.headline)
                    Text(statement.transaction.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text(statement.transaction == .deposit ? "+" : "-")
                            .foregroundColor(statement.transaction == .deposit ? .green : .red)
                        Text("$\(statement.amount, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(statement.transaction == .deposit ? .green : .red)
                    }
                    Text("Balance: $\(statement.availableBalance, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text(statement.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(.vertical, 2)
    }
}


