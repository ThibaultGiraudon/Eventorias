//
//  User.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import FirebaseFirestore

/// A model representing a user.
///
/// Includes basic identity details and a list of event IDs the user has created or subscribed to.
struct User: Hashable {
    
    // MARK: - Properties

    /// The unique identifier of the user (UID from Firebase).
    let uid: String

    /// The user's email address.
    var email: String

    /// The user's full name.
    var fullname: String

    /// The URL of the user's profile image.
    var imageURL: String

    /// A list of event IDs created by the user.
    var createdEvents: [String] = []

    /// A list of event IDs the user is subscribed to.
    var subscribedEvents: [String] = []

    /// The default profile image URL used when no image is provided.
    let defaultImage: String = "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/profils_image%2Fdefault-profile-image.jpg?alt=media&token=c9a78295-2ad4-4acf-872d-c193116783c5"

    // MARK: - Initializers

    /// Initializes a new `User` with the specified data.
    ///
    /// - Parameters:
    ///   - uid: The user's unique identifier.
    ///   - email: The user's email address.
    ///   - fullname: The user's full name.
    ///   - imageURL: An optional profile image URL. If nil, a default image URL is used.
    init(uid: String, email: String, fullname: String, imageURL: String?) {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL ?? defaultImage
    }

    /// Initializes a default (empty) `User` with a generated UID and default image.
    init() {
        self.uid = UUID().uuidString
        self.email = ""
        self.fullname = ""
        self.imageURL = defaultImage
    }

    /// Initializes a `User` instance from a Firestore document snapshot.
    ///
    /// - Parameter document: A `DocumentSnapshot` from Firestore containing user data.
    /// - Returns: `nil` if the required fields are missing or invalid.
    init?(data: [String: Any]?, uid: String) {
        guard let data = data,
              let email = data["email"] as? String,
              let fullname = data["fullname"] as? String,
              let createdEvents = data["createdEvents"] as? [String],
              let subscribedEvents = data["subscribedEvents"] as? [String] else {
            return nil
        }

        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.createdEvents = createdEvents
        self.subscribedEvents = subscribedEvents
        self.imageURL = data["imageURL"] as? String ?? defaultImage
    }
}
