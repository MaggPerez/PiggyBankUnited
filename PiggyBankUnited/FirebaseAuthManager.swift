//
//  FirebaseAuthManager.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 12/31/25.
//

import Foundation
import FirebaseAuth
import Combine

class FirebaseAuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    init() {
        //check if user is already signed in
        self.isAuthenticated = Auth.auth().currentUser != nil
        
        //listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil}
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
}
