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

class FirebaseAuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    private var isPreviewMode: Bool = false
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init(isPreview: Bool = false) {
        self.isPreviewMode = isPreview

        // Skip Firebase calls in preview mode to avoid timeouts
        if isPreview {
            self.isAuthenticated = false
            return
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
}
