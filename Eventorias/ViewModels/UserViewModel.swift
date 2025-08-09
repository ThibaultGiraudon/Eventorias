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

    private var events: [Event]
    var createdEvents: [Event] {
        events.filter( {$0.creatorID == currentUser?.uid }).sorted(by: { $0.date > $1.date })
    }
    var subscribedEvents: [Event] {
        events.filter( { $0.participants.contains(currentUser?.uid ?? "unknow") }).sorted(by: { $0.date > $1.date })
    }
    // MARK: - Private Propeties
    
    private let userRepository: UserRepositoryInterface
    private let authRepository: AuthRepositoryInterface
    private let storageRepository: StorageRepositoryInterface
    private let eventsRepository: EventsRepositoryInterface

    // MARK: - Initializer
    
    /// Initializes a nes `UserSessionViewModel`.
    ///
    /// - Parameters:
    ///   - userRepository: The user data repository (default is `UserRepository()`).
    ///   - authRepository: The authentication repository (default is `AuthRepository()`).
    init(userRepository: UserRepositoryInterface = UserRepository(),
         authRepository: AuthRepositoryInterface = AuthRepository(),
         storageRepository: StorageRepositoryInterface = StorageRepository(),
         eventsRepository: EventsRepositoryInterface = EventsRepository(),
         events: [Event] = []) {
        self.userRepository = userRepository
        self.authRepository = authRepository
        self.storageRepository = storageRepository
        self.eventsRepository = eventsRepository
        self.events = events
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
                self.error = "retreiving personnal information"
                return
            }
            events = try await eventsRepository.getEvents()
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            self.error = "retreiving personnal information"
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
        guard var user = currentUser else {
            self.error = "User not logged in"
            return
        }
        user.email = email
        user.fullname = fullname
        do {
            try await authRepository.editUser(email: email)
            userRepository.setUser(user)
            self.currentUser = user
        } catch {
            self.error = "updating user's personnal information"
        }
    }
    
    /// Uploads the given image thanks to the StorageRepository.
    /// Deletes the old one if it wasn't the default image.
    ///
    /// - Parameter image: The `UIImage` to save.
    func uploadImage(_ image: UIImage) async {
        guard var user = currentUser else {
            self.error = "User not logged in"
            return
        }
        do {
            let currentImageURL = user.imageURL
            let imageURL = try await storageRepository.uploadImage(image, to: "profils_image")
            user.imageURL = imageURL
            userRepository.setUser(user)
            if currentImageURL != user.defaultImage {
                try await storageRepository.deleteImage(with: currentImageURL)
            }
            self.currentUser = user
        } catch {
            self.error = "uploading new user's profile picture"
            return
        }
    }
    
    func addEvent(_ event: Event, to type: EventsType) async {
        guard var user = currentUser else {
            self.error = "User not logged in"
            return
        }
        switch type {
        case .created:
            user.createdEvents.append(event.id)
        case .subscribed:
            user.subscribedEvents.append(event.id)
        }
        do {
            userRepository.setUser(user)
            self.currentUser = user
            var editedEvent = event
            editedEvent.participants.append(user.uid)
            try eventsRepository.setEvent(editedEvent)
            events = try await eventsRepository.getEvents()
        } catch {
            self.error = "subscribing to the event"
        }
    }
    
    func removeEvent(_ event: Event) async {
        guard var user = currentUser else {
            self.error = "User not logged in"
            return
        }
        
        do {
            if user.subscribedEvents.contains(event.id) {
                user.subscribedEvents.removeAll(where: { $0 == event.id })
                userRepository.setUser(user)
                self.currentUser = user
                var editedEvent = event
                editedEvent.participants.removeAll(where: { $0 == user.uid })
                try eventsRepository.setEvent(editedEvent)
                events = try await eventsRepository.getEvents()
            }
        } catch {
            self.error = "unsubscribing to the event"
        }
    }

    /// Logs out the current user and clears the session state.
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
    }
}

enum EventsType {
    case created, subscribed
}
