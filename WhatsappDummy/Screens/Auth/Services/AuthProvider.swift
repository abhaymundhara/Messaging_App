//
//  AuthProvider.swift
//  WhatsappClone
//
//  Created by abhay mundhara on 03/06/2024.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum AuthState {
    case pending, loggedIn(UserItem), loggedOut
}

protocol AuthProvider{
    static var shared: AuthProvider { get }
    var authState: CurrentValueSubject<AuthState, Never> { get }
    func autoLogin() async
    func login(with email: String, and password: String) async throws
    func creatAccount(for username: String, with email: String, and password: String) async throws
    func logOut() async throws
}

enum AuthError: Error {
    case accountsCreationFailed(_ description: String)
    case failedToSaveUserInfo(_ description: String)
    case emailLoginFailed(_ description: String)
    
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accountsCreationFailed(let description):
            return description
        case .failedToSaveUserInfo(let description):
            return description
        case.emailLoginFailed(let description):
            return description
        }
    }
}

final class AuthManager: AuthProvider {
    
    private init() {
        Task {
            await autoLogin()
        }
    }
    
    static var shared: AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        }
        else {
                 fetchCurrentUserInfo()
        }
    }
    
    func login(with email: String, and password: String) async throws {
        do{
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUserInfo()
            print("🔒 Successfully signed in \(authResult.user.email ?? "")")
        } catch {
            print("🔒 failed to sign in the account with: \(email)")
            throw AuthError.emailLoginFailed(error.localizedDescription)
        }
    }
    
    func creatAccount(for username: String, with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, username: username, email: email)
            try await saveUserInfoDb(user: newUser)
            self.authState.send(.loggedIn(newUser))
            
        } catch {
            print("🔒 failed to create account: \(error.localizedDescription)")
            throw AuthError.accountsCreationFailed(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("🔒 successfully logged out of account: ")
        } catch {
            print("🔒 failed to log out of account: \(error.localizedDescription)")
        }
    }
}

extension AuthManager {
    private func saveUserInfoDb(user: UserItem) async throws {
        do {
            let userDictionary: [String: Any] = ["uid": user.uid, .username : user.username, .email : user.email]
            
            try await FirebaseConstants.UserRef.child(user.uid).setValue(userDictionary)
        } catch {
            print("🔒 failed to save create user account info: \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(error.localizedDescription)
        }
        }
    private func fetchCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserRef.child(currentUid).observe(.value) {[weak self] snapshot in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            let loggedInUser = UserItem(dictionary: userDict)
            self?.authState.send(.loggedIn(loggedInUser))
            print("user: \(loggedInUser.username) is logged")
        } withCancel: { error in
            print ("Failed to get current user id")
        }
    }
}

extension AuthManager {
    static let testAccounts: [String] = [
    "User1@gmail.com",
    "User2@gmail.com",
    "User3@gmail.com",
    "User4@gmail.com",
    "User5@gmail.com",
    "User6@gmail.com",
    "User7@gmail.com",
    "User8@gmail.com",
    "User9@gmail.com",
    "User10@gmail.com",
    "User11@gmail.com",
    "User12@gmail.com",
    "User13@gmail.com",
    "User14@gmail.com",
    "User15@gmail.com",
    "User16@gmail.com",
    "User17@gmail.com",
    "User18@gmail.com",
    "User19@gmail.com",
    "User20@gmail.com"
    ]
}

