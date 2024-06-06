//
//  AuthScreenModel.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 03/06/2024.
//

import Foundation

@MainActor
final class AuthScreenModel: ObservableObject {
    
    //Published properties
    
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Oops!")
    
    var disableLoginButton: Bool {
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool {
        return email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }
    
    func handleSignUp() async {
        isLoading = true
        do{
            try await AuthManager.shared.creatAccount(for: username, with: email, and: password)
        } catch {
            errorState.errorMessage = "Failed to create account \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
    
    func handleLogin() async {
        isLoading = true
        do {
            try await AuthManager.shared.login(with: email, and: password)
        } catch {
            errorState.errorMessage = "Failed to login \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
