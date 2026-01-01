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
    @State private var showSignUpView = false
    
    var body: some View {
        if showSignUpView {
            //sign up
            SignUpView(showSignUpView: $showSignUpView)
        } else {
            //login
            LoginView(showSignUpView: $showSignUpView)
        }
    }
}

struct LoginView: View {
    @Binding var showSignUpView: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject private var firebaseInstance = FirebaseAuthManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("PiggyBankUnited")
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
                
                //signin button
                Button("Signin") {
                    firebaseInstance.signIn(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                
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


struct SignUpView: View {
    @Binding var showSignUpView: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject private var firebaseInstance = FirebaseAuthManager()
    
    
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
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
                
                //signin button
                Button("Sign up") {
                    firebaseInstance.signUp(email: email, password: password)
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
