//
//  UserRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import Firebase

/// A repository class that handles all user-related operation using Firebase Firestore.
class UserRepository: UserRepositoryInterface {
    let db = Firestore.firestore()
    
    /// Retrieves a user document from Firestore using the specified UID.
    ///
    /// - Parameter uid: The unique identifier of the user.
    /// - Returns: A `User` object if found, otherwise `nil`.
    /// - Throws: An error if the Firestore fetch operation fails.
    func getUser(withId uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        return User(document: document)
    }
    
    /// Creates or updates a user document in Firestore with new the given user information.
    ///
    /// - Parameters:
    ///   - user: The `User` to be created or updated.
    ///   - completion: A closure called with an optionnal error if the opperation failed.
    func setUser(_ user: User) {
        let data: [String: Any] = [
            "email": user.email,
            "fullname": user.fullname,
            "imageURL": user.imageURL,
            "createdEvents": user.createdEvents,
            "subscribedEvents": user.subscribedEvents,
            "uid": user.uid
        ]
        
        db.collection("users").document(user.uid).setData(data)
    }
    
    func setData(_ data: [String: Any], id: String) {
        db.collection("users").document(id).setData(data)
    }
}
