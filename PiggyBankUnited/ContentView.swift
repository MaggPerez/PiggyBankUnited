//
//  ContentView.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 12/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("PiggyBankUnited")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 16) {
                TextField("Enter email", text: $email)
                    .disableAutocorrection(true)
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
                    .textContentType(.password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                
            }
            .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
