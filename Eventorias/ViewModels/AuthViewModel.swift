//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

/// A view model responsible for managing user authentication logic,
/// including sign in, registration and sign out.
///
/// This viewmodel interacts with `AuthRepository` for authentication
/// and `UserRepository` for user data persistence.
/// It also uses `UserSessionViewModel` to load and manage the current user session.
@MainActor
class AuthenticationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The user's email address.
    @Published var email = ""
    
    /// The user's password.
    @Published var password = ""
    
    /// The user's full name.
    @Published var fullname = ""
    
    /// An optional error message to be displayed in the UI if an operation failed.
    @Published var error: String?
    
    @Published var authenticationState: AuthenticationState = .signedOut

    // MARK: - Private Properties
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private unowned let session: UserSessionViewModel
    
    // MARK: - Initializer

    /// Initializes a new `AuthenticationViewModel`.
    ///
    /// - Parameters:
    ///   - session: The current user session view model.
    ///   - authRepository: The authentication repository ( default is `AuthRepository()`).
    ///   - userRepository: The user data repository ( default is `UserRepository()`).
    init(session: UserSessionViewModel,
         authRepository: AuthRepository = .init(),
         userRepository: UserRepository = .init()) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.session = session
    }

    // MARK: - Methods
    
    /// Signs in the suer using the current `email` and `password`.
    /// Stores user data in `UserSessionViewModel`.
    ///
    /// - Parameter completion: A closure called upon successful authentication.
    func signIn(completion: @escaping () -> Void) {
        authenticationState = .signingIn
        authRepository.authenticate(email: email, password: password) { result, error in
            if let error = error {
                print("Sign in error: \(error)")
                self.error = self.authRepository.identifyError(error)
                self.authenticationState = .signedOut
                return
            }

            guard let uid = result?.user.uid else {
                self.authenticationState = .signedOut
                return
            }

            Task {
                await self.session.loadUser(by: uid)
                // TODO: ask user for "remember me" before saving credentials
                KeychainHelper.shared.save(self.email, for: "UserEmail")
                KeychainHelper.shared.save(self.password, for: "UserPassword")
                completion()
                self.authenticationState = .signedIn
            }
        }
    }

    /// Registers a new user with the current `email`, `password` and `fullname`,
    /// saves user data in Firestore, and stores user data in `UserSessionViewModel`.
    ///
    /// - Parameter completion: A closure called upon successful registration.
    func register(completion: @escaping () -> Void) {
        self.authenticationState = .signingIn
        authRepository.register(email: email, password: password) { result, error in
            if let error = error {
                print("Register error: \(error)")
                self.error = self.authRepository.identifyError(error)
                self.authenticationState = .signedOut
                return
            }

            guard let uid = result?.user.uid else {
                self.authenticationState = .signedOut
                return
            }

            let newUser = User(uid: uid, email: self.email, fullname: self.fullname, imageURL: nil)

            self.userRepository.setUser(newUser) { error in
                if let error = error {
                    print("Saving user failed: \(error)")
                    return
                }

                Task {
                    await self.session.loadUser(by: uid)
                    completion()
                    KeychainHelper.shared.save(self.email, for: "UserEmail")
                    KeychainHelper.shared.save(self.password, for: "UserPassword")
                    self.authenticationState = .signedIn
                }
            }
        }
    }

    /// Signs out the current user and clears the `UserSessionViewModel`.
    func signOut() {
        authRepository.signOut { error in
            if let error = error {
                print("Sign out error: \(error)")
                self.error = error.localizedDescription
                self.authenticationState = .signedIn
                return
            }
            self.session.logout()
            self.authenticationState = .signedOut
        }
    }
}

enum AuthenticationState {
    case signedOut, signingIn, signedIn
}
