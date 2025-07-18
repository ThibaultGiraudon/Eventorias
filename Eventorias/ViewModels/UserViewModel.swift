//
//  UserViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

/// A view model responsible for managing user operations such as:
/// retrieving lthe currently logged-in user and updating user information.
///
/// This view model interacts with `AuthRepository` for email updates
/// and `UserRepository` for user data persistence.
@MainActor
class UserSessionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The currently logged-in user.
    @Published var currentUser: User?
    
    /// A Boolean indicating whether the user is currently logged in.
    @Published var isLoggedIn: Bool = false
    
    /// A Boolean indicating whether a user-related operation is in progress.
    @Published var isLoading: Bool = false
    
    /// An optional error message to be displayed in the UI if an operation fails.
    @Published var error: String?

    // MARK: - Private Propeties
    
    private let userRepository: UserRepository
    private let authRepository: AuthRepository

    // MARK: - Initializer
    
    /// Initializes a nes `UserSessionViewModel`.
    ///
    /// - Parameters:
    ///   - userRepository: The user data repository (default is `UserRepository()`).
    ///   - authRepository: The authentication repository (default is `AuthRepository()`).
    init(userRepository: UserRepository = .init(),
         authRepository: AuthRepository = .init()) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }

    // MARK: - Methods
    
    /// Loads the user with the given UID from th repository.
    ///
    /// - Parameter uid: The unique identifier of the user.
    func loadUser(by uid: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            guard let user = try await userRepository.getUser(withId: uid) else {
                error = "User not found"
                return
            }
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    
    /// Updates the user's personal information such as:
    /// `email`, `fullname` and `imageURL`.
    ///
    /// ⚠️ **Note:** Updating the email currently does not work as expected.
    /// No error is returned, but the email may not be updated in Firebase Authentication.
    ///
    /// - Parameters:
    ///   - email: The new  email.
    ///   - fullname: The new  full name.
    ///   - imageURL: The new  image URL.
    func updateUser(email: String, fullname: String, imageURL: String) {
        currentUser?.email = email
        currentUser?.fullname = fullname
        currentUser?.imageURL = imageURL
        guard let user = currentUser else {
            return
        }
        userRepository.setUser(user) { error in
            self.error = error?.localizedDescription
            print(error ?? "User updated successfuly")
        }
        authRepository.editUser(email: email) { error in
            self.error = error?.localizedDescription
            print(error ?? "Successfuly change email to \(email)")
        }
    }

    /// Logs out the current user and clears the session state.
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
    }
}
