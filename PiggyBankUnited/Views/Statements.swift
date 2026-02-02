//
//  Statements.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 2/2/26.
//

import SwiftUI

struct StatementsView: View {
    @ObservedObject var firebaseAuthManager: FirebaseAuthManager
    @State private var statements: [Statement] = []
    @State private var isLoading = true
    
    var body: some View {
        
            VStack {
                VStack {
                    //loading statements
                    if isLoading {
                        ProgressView("Loading statements...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    //shows message that statements are empty
                    } else if statements.isEmpty {
                        ContentUnavailableView(
                            "No Statements",
                            systemImage: "doc.text",
                            description: Text("You don't have any transactions yet.")
                        )
                    
                    //displays user's statements if there are any
                    } else {
                        List(statements) { statement in
                            StatementRowView(statement: statement)
                        }
                        .refreshable {
                            await fetchStatements()
                        }
                    }
                }
            }
        
            //fetches statements
            .task {
                await fetchStatements()
            }
            .navigationTitle("Statements")
                  
        
    }

    /**
     function to fetch user's statement
     */
    private func fetchStatements() async {
        isLoading = true

        let fetchedStatements = await firebaseAuthManager.getUserStatement()
        statements = fetchedStatements
        isLoading = false
    }
}

#Preview {
    StatementsView(firebaseAuthManager: .preview)
}
