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
import FirebaseFunctions
import StreamVideo

enum AuthState {
    case pending, loggedIn(UserItem), loggedOut
}

protocol AuthProvider {
    static var shared: AuthProvider { get }
    var authState: CurrentValueSubject<AuthState, Never> { get }
    func autoLogin() async
    func login(with email: String, and password: String) async throws
    func createAccount(for username: String, with email: String, and password: String) async throws
    func logOut() async throws
}

enum AuthError: Error {
    case accountCreationFailed(_ description: String)
    case failedToSaveUserInfo(_ description: String)
    case emailLoginFailed(_ description: String)
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accountCreationFailed(let description):
            return description
        case .failedToSaveUserInfo(let description):
            return description
        case .emailLoginFailed(let description):
            return description
        }
    }
}

final class AuthManager: AuthProvider {

    private init() {
        Task { await autoLogin() }
    }

    static let shared: AuthProvider = AuthManager()

    var authState = CurrentValueSubject<AuthState, Never>(.pending)

    @Published var streamVideo: StreamVideo?

    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        } else {
            fetchCurrentUserInfo {[weak self] currentUser in
                self?.setUp(currentUser)
            }
        }
    }

    func login(with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUserInfo {[weak self] currentUser in
                self?.setUp(currentUser)
            }
            print("🔐 Successfully Signed In \(authResult.user.email ?? "") ")
        } catch {
            print("🔐 Failed to Sign Into the Account with: \(email)")
            throw AuthError.emailLoginFailed(error.localizedDescription)
        }
    }

    func createAccount(for username: String, with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, username: username, email: email)
            try await saveUserInfoDatabase(user: newUser)
            setUp(newUser)
        } catch {
            print("🔐 Failed to Create an Account: \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }

    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("🔐 Successfully logged out!")
        } catch {
            print("🔐 Failed to logOut current User: \(error.localizedDescription)")
        }
    }
}

extension AuthManager {
    private func saveUserInfoDatabase(user: UserItem) async throws {
        do {
            let userDictionary: [String: Any] = [.uid : user.uid, .username : user.username, .email : user.email]
            try await FirebaseConstants.UserRef.child(user.uid).setValue(userDictionary)
        } catch {
            print("🔐 Failed to Save Created user Info to Database: \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(error.localizedDescription)
        }
    }

    private func fetchCurrentUserInfo(completion: @escaping(UserItem) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserRef.child(currentUid).observe(.value) {[weak self] snapshot in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            let loggedInUser = UserItem(dictionary: userDict)
            completion(loggedInUser)
            self?.authState.send(.loggedIn(loggedInUser))
            print("🔐 \(loggedInUser.username) is logged in")
        } withCancel: { error in
            print("Failed to get current user info")
        }
    }

    private func setUp(_ currentUser: UserItem) {
        Task { await setUpStreamVideo(for: currentUser) }
        authState.send(.loggedIn(currentUser))
    }
}

extension AuthManager {
    // Fix B11 + B21: removed hardcoded API key, JWT token, and Qui-Gon_Jinn user.
    // Now calls the getStreamUserToken Cloud Function and uses the real logged-in user.
    private func setUpStreamVideo(for currentUser: UserItem) async {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "STREAM_API_KEY") as? String,
              !apiKey.isEmpty else {
            print("⚠️ STREAM_API_KEY missing from Info.plist")
            return
        }

        do {
            let functions = Functions.functions()
            let result = try await functions.httpsCallable("getStreamUserToken").call()
            guard let rawToken = result.data as? String else {
                print("⚠️ Failed to parse Stream token from Cloud Function")
                return
            }

            let token = UserToken(rawValue: rawToken)
            // Use the actual logged-in user, not a hardcoded placeholder
            let streamUser = User(
                id: currentUser.uid,
                name: currentUser.username,
                imageURL: currentUser.profileImageUrl.flatMap { URL(string: $0) }
            )

            await MainActor.run {
                streamVideo = StreamVideo(apiKey: apiKey, user: streamUser, token: token)
            }
        } catch {
            print("⚠️ Failed to get Stream token: \(error.localizedDescription)")
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
