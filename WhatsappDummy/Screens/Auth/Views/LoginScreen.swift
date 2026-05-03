//
//  LoginScreen.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 03/06/2024.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @StateObject private var authScreenModel = AuthScreenModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()

                AuthTextField(type: .email, text: $authScreenModel.email)
                AuthTextField(type: .password, text: $authScreenModel.password)

                forgotPasswordButton()

                AuthButton(title: "Log in now") {
                    Task { await authScreenModel.handleLogin() }
                }
                .disabled(authScreenModel.disableLoginButton)

                Spacer()

                signUpButton()
                    .padding(.bottom, 30)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorState.showError) {
                Alert(
                    title: Text(authScreenModel.errorState.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }

    // Fix B13: was an empty no-op. Now sends a Firebase password-reset email
    // when the email field is non-empty; shows an error if email is blank.
    private func forgotPasswordButton() -> some View {
        Button {
            guard !authScreenModel.email.isEmpty else {
                authScreenModel.errorState = (true, "Please enter your email address first.")
                return
            }
            Auth.auth().sendPasswordReset(withEmail: authScreenModel.email) { error in
                if let error = error {
                    authScreenModel.errorState = (true, error.localizedDescription)
                } else {
                    authScreenModel.errorState = (true, "Password reset email sent to \(authScreenModel.email).")
                }
            }
        } label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
        }
    }

    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreen(authScreenModel: authScreenModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                (
                    Text("Don't have an account ? ")
                    +
                    Text("Create one").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
