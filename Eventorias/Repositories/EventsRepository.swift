//
//  EventsRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import FirebaseFirestore

/// A repository class that handles all events-related operations using Firebase Firestore.
class EventsRepository: EventsRepositoryInterface {
    let db = Firestore.firestore()
    
    /// Retrieves all events documents from Firestore.
    ///
    /// - Returns: An `Event` array..
    /// - Throws: An error if the Firestore fetch operation fails.
    func getEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        
        let documents = snapshot.documents
        let items = documents.compactMap {
            try? $0.data(as: Event.self)
        }
        
        return items
    }
    
    /// Creates or updates a user document in Firestore with new the given user information.
    ///
    /// - Parameter event: The `Event` to be created or updated.
    /// - Throws: An error if the Firestore set operation fails.
    func setEvent(_ event: Event) throws {
        try db.document("events/\(event.id)").setData(from: event)
    }
    
    /// Deletes the event with the given id.
    ///
    /// - Parameter id: The unique identifier of the event to be deleted
    func deleteEvent(with id: String) {
        db.document("events/\(id)").delete()
    }
    
    /// Deletes all events from the database.
    ///
    /// - Throws: An error if the Firestore fetch operation fails.
    func clearDB() async throws {
        let events = try await self.getEvents()
        
        for event in events {
            self.deleteEvent(with: event.id)
        }
    }
}
