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
    
    /**
     funciton to sign up
     */
    func signUp(email: String, password: String){
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                
                return
            }
            // isAuthenticated will be set by the auth state listener
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
    
    func depositAmount(amount: Double) async {
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
                let currentBalance = document.data()?["balance"] as? Double ?? 0.0
                let newBalance = currentBalance + amount
                
                try await docRef.updateData([
                    "balance": newBalance
                ])
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
}
