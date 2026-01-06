//
// ContentView.swift
// PiggyBankUnited
//
// Created by Magdaleno A Perez on 12/31/25.
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
            MainContentView(showMainContent: $authManager.isAuthenticated, firebaseAuthManager: authManager)
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
        ZStack {
            // Blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.4, blue: 0.8),
                    Color(red: 0.0, green: 0.5, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo and Title
                VStack(spacing: 16) {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Text("Piggy Bank United")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Welcome back")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 20)
                
                // White card container
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        
                        //enter your credentials
                        Text("Enter your credentials")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        //enter email textfield
                        TextField("Enter Email", text: $email)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        
                        //enter password textfield
                        SecureField("Enter Password", text: $password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .textContentType(.password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        
                        // Sign in button
                        Button(action: {
                            authManager.signIn(email: email, password: password)
                        }) {
                            Text("Sign In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.0, green: 0.4, blue: 0.8),
                                            Color(red: 0.0, green: 0.5, blue: 0.9)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.0, green: 0.4, blue: 0.8).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 8)
                        
                        // Don't have an account
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.secondary)
                            
                            Button("Sign Up") {
                                showSignUpView = true
                            }
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            .fontWeight(.semibold)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
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
        ZStack {
            // Blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.4, blue: 0.8),
                    Color(red: 0.0, green: 0.5, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo and Title
                VStack(spacing: 16) {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Text("Piggy Bank United")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Create your account")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 20)
                
                // White card container
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        
                        //create your credentials
                        Text("Create your credentials")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        //create email textfield
                        TextField("Create Email", text: $email)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        
                        //create password textfield
                        SecureField("Create Password", text: $password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .textContentType(.newPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        
                        // Sign up button
                        Button(action: {
                            authManager.signUp(email: email, password: password)
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.0, green: 0.4, blue: 0.8),
                                            Color(red: 0.0, green: 0.5, blue: 0.9)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.0, green: 0.4, blue: 0.8).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 8)
                        
                        // Already have an account
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.secondary)
                            
                            Button("Sign In") {
                                showSignUpView = false
                            }
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            .fontWeight(.semibold)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}



#Preview {
    ContentView()
}
