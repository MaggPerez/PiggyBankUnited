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
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
        }
    }
}
