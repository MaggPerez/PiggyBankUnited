//
//  FirebaseAuthManager.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 12/31/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import Combine
import FirebaseFirestore


class FirebaseAuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var currentBalance: Double = 0.0
    private var isPreviewMode: Bool = false
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()


    

    init(isPreview: Bool = false) {
        self.isPreviewMode = isPreview

        // Skip Firebase calls in preview mode to avoid timeouts
        if isPreview {
            self.isAuthenticated = false
            return
        }
        
        //configure firebase if anot already configured
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        //check if user is already signed in
        self.isAuthenticated = Auth.auth().currentUser != nil
        

        //listen for auth state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil}
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    
    
    // MARK: - Preview Helper
    /// Returns a FirebaseAuthManager instance configured for SwiftUI previews
    /// This instance won't connect to Firebase to avoid preview timeouts
    static var preview: FirebaseAuthManager {
        return FirebaseAuthManager(isPreview: true)
    }
    
    
    //MARK: - Signup/in functionalities
    
    /**
     funciton to sign up
     */
    func signUp(email: String, password: String, name: String){
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            // Now that user creation succeeded, add user's extra credentials
            guard let currentUser = authResult?.user else {
                self.errorMessage = "Failed to get created user"
                return
            }
            
            // Set user data in Firestore
            self.db.collection("users").document(currentUser.uid).setData([
                "name": name
            ]) { error in
                if let error = error {
                    self.errorMessage = "Error saving user data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    /**
     function to sign in
     */
    func signIn(email: String, password: String) {
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                
                return
            }
            // isAuthenticated will be set by the auth state listener
        }
        
    }
    
    
    /**
     function to sign out
     */
    func signOut() {
        do {
            try Auth.auth().signOut()
            // isAuthenticated will be set by the auth state listener
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func getUserEmail() -> String? {
        // Return mock data in preview mode
        if isPreviewMode {
            return "user@example.com"
        }

        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user is currently signed in"
            return nil
        }
        return user.email
    }
    
    
    // MARK: - Transaction behaviors
    
    /**
     function to deposit amount
     */
    func depositAmount(amount: Double, account: String) async {
        //checking if the user is authenticated
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "No user is currently signed in"
            return
        }
        
        let docRef = db.collection("users").document(currentUser.uid)
        
        //adding user's deposit amount to db
        do {
            let document = try await docRef.getDocument()
            
            //checking if the user already exists in db
            if document.exists {
                //get current balance from user
                let currentBalance = document.data()?[account] as? Double ?? 0.0
                let newBalance = currentBalance + amount
                
                //updating balance
                try await docRef.updateData([
                    account: newBalance
                ])
                
                //updating UI
                self.currentBalance = newBalance
                await recordTransaction(account: account, amount: amount, transactionType: "Deposit")
                
                print("Added \(amount) to existing balance")
            }
            else {
                //adding new user to the db
                try await db.collection("users").document(currentUser.uid).setData([
                    "balance": amount
                ])
                print("New user created with initial balance: \(amount)")
            }
            
        } catch {
            errorMessage = "Error updating balance: \(error.localizedDescription)"
            print("Error adding document: \(error)")
        }
    }
    
    
    
    /**
     function to withdraw
     */
    func withdrawAmount(amount: Double, account: String) async {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated"
            return
        }
        
        let docRef = db.collection("users").document(currentUser.uid)
        
        //subtracting user's withdraw amount to db
        do {
            let document = try await docRef.getDocument()
            
            //checking if the user already exists in db
            if document.exists {
                //get current balance from user based on the account they're on "Checkings, Savings, etc..."
                let currentBalance = document.data()?[account] as? Double ?? 0.0
                let newBalance = currentBalance - amount
                
                //updating balance
                try await docRef.updateData([
                    account: newBalance
                ])
                
                //updating UI
                self.currentBalance = newBalance
                await recordTransaction(account: account, amount: amount, transactionType: "Withdrawal")
                
                print("Added \(amount) to existing balance")
            }
            else {
                //adding new user to the db
                try await db.collection("users").document(currentUser.uid).setData([
                    "balance": amount
                ])
                print("New user created with initial balance: \(amount)")
            }
            
        } catch {
            errorMessage = "Error updating balance: \(error.localizedDescription)"
            print("Error adding document: \(error)")
        }
        
        
    }
    
    
    
    /**
     function to get user's account through firestore db
     */
    func getUserFirestoreAccount() -> DocumentReference? {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated"
            return nil
        }
        return db.collection("users").document(currentUser.uid)
    }
    
    
    
    /**
     function that gets user's balance based on the account they're on
     */
    func getUserBalance(account: String) async {
        if (isPreviewMode) {
            return self.currentBalance = 100.00
        }
        
        var currentBalance: Double = 0.0
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated"
            return self.currentBalance = 0.0
        }
        
        let docRef = db.collection("users").document(currentUser.uid)
        
        
        do {
            let document = try await docRef.getDocument()
            
            //checking if user balance exists
            if document.exists {
                currentBalance = document.data()?[account] as? Double ?? 0.0
                self.currentBalance = currentBalance
            }
            
        }
        catch {
            errorMessage = "Error getting user's balance: \(error.localizedDescription)"
            print("Error adding document: \(error)")
            
            self.currentBalance = 0.0
        }
        
        
    }
    
    
    // MARK: - Recording Transactions
    
    
    /**
     function that sets statements for each transaction that user makes
     */
    func recordTransaction(account: String, amount: Double, transactionType: String) async {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated"
            return
        }
        
        
        let currentDate = getCurrentDateFormatted()
        
        do {
            try await db.collection("users").document(currentUser.uid).collection("statements").addDocument(data: [
                "Account": account,
                "Amount": amount,
                "Transaction": transactionType,
                "Available Balance": self.currentBalance,
                "Date": currentDate
            ])
        } catch {
            errorMessage = "Error adding document"
        }
    }
    
    
    
    /**
     function to get current data with proper date format
     */
    func getCurrentDateFormatted() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.string(from: currentDate)
    }
    
    func formatGivenDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.date(from: date) ?? Date()
    }
    
    
    /**
     function to get user's statement
     */
    func getUserStatement() async -> [Statement] {
        if (isPreviewMode) {
            var previewStatements: [Statement] = []
            let statement = Statement(account: "Checkings", amount: 150, transaction: TransactionType.deposit, availableBalance: 300, date: Date())
            previewStatements.append(statement)
            return previewStatements
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated"
            return []
        }
        
        var fetchedStatements: [Statement] = []
        
        do {
            let querySnapShot = try await db.collection("users").document(currentUser.uid).collection("statements").getDocuments()
            
            for document in querySnapShot.documents {
                let data = document.data()
                //parsing firestore data into Statement model
                if let account = data["Account"] as? String,
                   let amount = data["Amount"] as? Double,
                   let transactionTypeString = data["Transaction"] as? String,
                   let availableBalance = data["Available Balance"] as? Double,
                   let dateString = data["Date"] as? String {
                    
                    //convert transaction string to enum
                    let transactionType: TransactionType = transactionTypeString == "Deposit" ? .deposit : .withdrawal
                    
                    //parse data string
                    let date = formatGivenDate(date: dateString)
                    
                    let statement = Statement(account: account, amount: amount, transaction: transactionType, availableBalance: availableBalance, date: date)
                    
                    fetchedStatements.append(statement)
                }
            }
            
        } catch {
            errorMessage = "Error fetching statements: \(error.localizedDescription)"
        }
        
        // Sort statements by date (newest first)
        return fetchedStatements.sorted { $0.date > $1.date }
    }
}
