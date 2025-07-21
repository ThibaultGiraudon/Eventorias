//
//  EventsRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import FirebaseFirestore

class EventsRepository {
    let db = Firestore.firestore()
    
    func getEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        
        let documents = snapshot.documents
        
        let items = documents.compactMap {
            try? $0.data(as: Event.self)
        }
        
        return items
    }
    
    func setEvent(_ event: Event) throws {
        try db.document("events/\(event.id)").setData(from: event)
    }
    
    func deleteEvent(with id: String) {
        db.document("events/\(id)").delete()
    }
}
