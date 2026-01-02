//
//  ContentView.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 12/31/25.
//

import SwiftUI
import Foundation
import FirebaseAuth


struct ContentView: View {
    @StateObject private var authManager = FirebaseAuthManager()
    @State private var showSignUpView = false
    
    var body: some View {
        if authManager.isAuthenticated {
            //dashboard view
            MainContentView(showMainContent: $authManager.isAuthenticated)
        }
        else if showSignUpView {
            //sign up view
            SignUpView(showSignUpView: $showSignUpView, authManager: authManager)
        }
        else {
            //login view
            LoginView(showSignUpView: $showSignUpView, authManager: authManager)
        }
    }
}


/**
 Sign in View
 */
struct LoginView: View {
    @Binding var showSignUpView: Bool
    @ObservedObject var authManager: FirebaseAuthManager
    
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "banknote")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("Piggy Bank United")
                .font(.largeTitle)
                .bold()
            
            Text("Welcome sign in!")
            
            VStack(spacing: 16) {
                TextField("Enter email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
                SecureField("Enter password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
                //sign in button
                Button("Sign in") {
                    authManager.signIn(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                
                
                //don't have an account
                HStack{
                    Text("Don't have an account?")
                    
                    Button("Create one") {
                        showSignUpView = true
                    }
                }
                       
            }
            .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

/**
 Sign up view
 */
struct SignUpView: View {
    @Binding var showSignUpView: Bool
    @ObservedObject var authManager: FirebaseAuthManager
    
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        
        VStack {
            Image(systemName: "banknote")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("PiggyBankUnited")
                .font(.largeTitle)
                .bold()
            
            Text("Welcome sign in!")
            
            VStack(spacing: 16) {
                TextField("Create email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
                SecureField("Create password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
                //sign up button
                Button("Sign up") {
                    authManager.signUp(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                
                
                HStack {
                    Text("Already have an account?")
                    
                    Button("Login") {
                        showSignUpView = false
                    }
                }
                
                
            }
            .textFieldStyle(.roundedBorder)
        }
        .padding()
        
        
    }
}



#Preview {
    ContentView()
}
