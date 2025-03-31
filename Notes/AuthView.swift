//
//  AuthView.swift
//  Notes
//
//  Created by Charles Yow on 3/31/25.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = Auth.auth().currentUser != nil
    @State private var errorMessage = ""

    var body: some View {
        if isLoggedIn {
            VStack {
                HStack {
                    Spacer()
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            isLoggedIn = false
                        } catch {
                            errorMessage = "Failed to sign out: \(error.localizedDescription)"
                        }
                    }
                    .padding()
                }

                ContentView()
            }
        } else {
            VStack(spacing: 20) {
                Text("Sign In / Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Button("Login") {
                    login()
                }
                .buttonStyle(.borderedProminent)

                Button("Sign Up") {
                    signUp()
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isLoggedIn = true
            }
        }
    }
}
