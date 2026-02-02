//
//  Statements.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 2/2/26.
//

import SwiftUI

struct StatementsView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    var body: some View {
        NavigationStack {
            VStack {
                StatementTableView(firebaseAuthManager: firebaseAuthManager)
            }
        }
        .navigationTitle("Statements")
    }
}
