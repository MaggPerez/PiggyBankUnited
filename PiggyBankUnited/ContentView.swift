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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Logo and header section
                    VStack(spacing: 12) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            .padding(.top, 60)

                        Text("Piggy Bank United")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))

                        Text("Secure Banking, Simplified")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.bottom, 40)
                    }

                    // Login form card
                    VStack(spacing: 24) {
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))

                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                    .frame(width: 20)

                                TextField("Enter your email", text: $email)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                    .frame(width: 20)

                                SecureField("Enter your password", text: $password)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .textContentType(.password)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                        }

                        // Forgot password
                        Button(action: {}) {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)

                        // Sign in button
                        Button(action: {
                            authManager.signIn(email: email, password: password)
                        }) {
                            Text("Sign In")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.0, green: 0.4, blue: 0.8),
                                            Color(red: 0.0, green: 0.35, blue: 0.7)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.0, green: 0.4, blue: 0.8).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 8)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)

                            Text("OR")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 12)

                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

                        // Sign up link
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)

                            Button(action: {
                                showSignUpView = true
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            }
                        }
                    }
                    .padding(28)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
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
    @State private var confirmPassword: String = ""

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Logo and header section
                    VStack(spacing: 12) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            .padding(.top, 60)

                        Text("Piggy Bank United")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))

                        Text("Start Your Financial Journey")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.bottom, 40)
                    }

                    // Sign up form card
                    VStack(spacing: 24) {
                        Text("Create Account")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))

                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                    .frame(width: 20)

                                TextField("Enter your email", text: $email)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                    .frame(width: 20)

                                SecureField("Create a password", text: $password)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .textContentType(.newPassword)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                        }

                        // Confirm Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                    .frame(width: 20)

                                SecureField("Confirm your password", text: $confirmPassword)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .textContentType(.newPassword)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.95), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                        }

                        // Terms and conditions
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                                .font(.system(size: 18))

                            Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 4)

                        // Sign up button
                        Button(action: {
                            authManager.signUp(email: email, password: password)
                        }) {
                            Text("Create Account")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.0, green: 0.4, blue: 0.8),
                                            Color(red: 0.0, green: 0.35, blue: 0.7)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.0, green: 0.4, blue: 0.8).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 8)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)

                            Text("OR")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 12)

                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)

                        // Login link
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)

                            Button(action: {
                                showSignUpView = false
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.8))
                            }
                        }
                    }
                    .padding(28)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
