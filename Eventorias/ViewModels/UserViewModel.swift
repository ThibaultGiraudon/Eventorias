//
//  UserViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import SwiftUI

/// A view model responsible for managing user operations such as:
/// retrieving lthe currently logged-in user and updating user information.
///
/// This view model interacts with `AuthRepository` for email updates,
/// `UserRepository` for user data persistence
/// and `StorageRepository` to saves user profile image.
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
    
    private let userRepository: UserRepositoryInterface
    private let authRepository: AuthRepositoryInterface
    private let storageRepository: StorageRepository

    // MARK: - Initializer
    
    /// Initializes a nes `UserSessionViewModel`.
    ///
    /// - Parameters:
    ///   - userRepository: The user data repository (default is `UserRepository()`).
    ///   - authRepository: The authentication repository (default is `AuthRepository()`).
    init(userRepository: UserRepositoryInterface = UserRepository(),
         authRepository: AuthRepositoryInterface = AuthRepository(),
         storageRepository: StorageRepository = StorageRepository()) {
        self.userRepository = userRepository
        self.authRepository = authRepository
        self.storageRepository = storageRepository
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
    func updateUser(email: String, fullname: String) async {
        guard let user = currentUser else {
            self.error = "User not logged in"
            return
        }
        let updatedUser = User(uid: user.uid, email: email, fullname: fullname, imageURL: user.imageURL)
        do {
            try await authRepository.editUser(email: email)
            userRepository.setUser(updatedUser)
            self.currentUser = updatedUser
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Uploads the given image thanks to the StorageRepository.
    /// Deletes the old one if it wasn't the default image.
    ///
    /// - Parameter image: The `UIImage` to save.
    func uploadImage(_ image: UIImage) async {
        guard let user = currentUser else {
            self.error = "User not logged in"
            return
        }
        do {
            let currentImageURL = user.imageURL
            let imageURL = try await storageRepository.uploadImage(image, to: "profils_image")
            print("Successfuly uploaded image")
            let updatedUser = User(uid: user.uid, email: user.email, fullname: user.fullname, imageURL: imageURL)
            userRepository.setUser(updatedUser)
            if currentImageURL != user.defaultImage {
                try await storageRepository.deleteImage(with: currentImageURL)
            }
            self.currentUser = updatedUser
            print("Successfuly updated user")
        } catch {
            self.error = "Failed to upload image"
            return
        }
    }

    /// Logs out the current user and clears the session state.
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
    }
}
