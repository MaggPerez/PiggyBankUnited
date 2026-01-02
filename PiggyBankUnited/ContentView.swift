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
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainContentView(showMainContent: $authManager.isAuthenticated)
                    .transition(.move(edge: .trailing))
            } else {
                AuthenticationView(authManager: authManager)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: authManager.isAuthenticated)
    }
}

struct AuthenticationView: View {
    @ObservedObject var authManager: FirebaseAuthManager
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            // Modern Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.0, green: 0.2, blue: 0.5), Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Logo / Branding
                VStack(spacing: 10) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.white.opacity(0.2)))
                        .shadow(radius: 5)
                    
                    Text("PiggyBank United")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    
                    Text("Banking for the Future")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 40)
                
                // Auth Card
                VStack(spacing: 25) {
                    // Toggle Switch
                    Picker("Mode", selection: $isLoginMode) {
                        Text("Log In").tag(true)
                        Text("Sign Up").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        // Email Input
                        CustomTextField(icon: "envelope.fill", placeholder: "Email Address", text: $email)
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        // Password Input
                        CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .textContentType(isLoginMode ? .password : .newPassword)
                    }
                    .padding(.horizontal)
                    
                    // Error Message
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)
                            .transition(.opacity)
                    }
                    
                    // Action Button
                    Button(action: handleAction) {
                        HStack {
                            Text(isLoginMode ? "Secure Log In" : "Create Account")
                                .fontWeight(.bold)
                            Image(systemName: isLoginMode ? "lock.open.fill" : "person.badge.plus.fill")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color(red: 0.0, green: 0.3, blue: 0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)

                }
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Footer
                if isLoginMode {
                    Button("Forgot Password?") {
                        // Action for forgot password
                    }
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)
                }
            }
            .animation(.spring(), value: isLoginMode)
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func handleAction() {
        focusedField = nil
        if isLoginMode {
            authManager.signIn(email: email, password: password)
        } else {
            authManager.signUp(email: email, password: password)
        }
    }
}

// Reusable Components
struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}