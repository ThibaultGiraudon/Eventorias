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
    
    private let authRepository: AuthRepositoryInterface
    private let userRepository: UserRepositoryInterface
    private let session: UserSessionViewModel
    
    // MARK: - Initializer

    /// Initializes a new `AuthenticationViewModel`.
    ///
    /// - Parameters:
    ///   - session: The current user session view model.
    ///   - authRepository: The authentication repository ( default is `AuthRepository()`).
    ///   - userRepository: The user data repository ( default is `UserRepository()`).
    init(session: UserSessionViewModel,
         authRepository: AuthRepositoryInterface = AuthRepository(),
         userRepository: UserRepositoryInterface = UserRepository()) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.session = session
    }

    // MARK: - Methods
    
    /// Signs in the suer using the current `email` and `password`.
    /// Stores user data in `UserSessionViewModel`.
    ///
    /// - Parameter completion: A closure called upon successful authentication.
    func signIn() async throws {
        authenticationState = .signingIn
        do {
            let uid = try await authRepository.authenticate(email: email, password: password)
            await session.loadUser(by: uid)
            KeychainHelper.shared.save(self.email, for: "UserEmail")
            KeychainHelper.shared.save(self.password, for: "UserPassword")
            self.authenticationState = .signedIn
        } catch {
            self.error = error.localizedDescription
            self.authenticationState = .signedOut
            throw error
        }
    }

    /// Registers a new user with the current `email`, `password` and `fullname`,
    /// saves user data in Firestore, and stores user data in `UserSessionViewModel`.
    ///
    /// - Parameter completion: A closure called upon successful registration.
    func register() async throws {
        self.authenticationState = .signingIn
        do {
            let uid = try await authRepository.register(email: email, password: password)
            let newUser = User(uid: uid, email: email, fullname: fullname, imageURL: nil)
            userRepository.setUser(newUser)
            await session.loadUser(by: uid)
            KeychainHelper.shared.save(self.email, for: "UserEmail")
            KeychainHelper.shared.save(self.password, for: "UserPassword")
            self.authenticationState = .signedIn
        } catch {
            self.error = error.localizedDescription
            self.authenticationState = .signedOut
            throw error
        }
    }

    /// Signs out the current user and clears the `UserSessionViewModel`.
    func signOut() async {
        do {
            try authRepository.signOut()
        } catch {
            self.error = error.localizedDescription
            self.authenticationState = .signedIn
        }
    }
}

enum AuthenticationState {
    case signedOut, signingIn, signedIn
}
