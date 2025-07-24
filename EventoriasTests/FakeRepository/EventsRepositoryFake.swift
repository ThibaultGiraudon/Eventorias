//
//  EventsRepositoryFake.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 23/07/2025.
//

import Foundation
@testable import Eventorias

class EventsRepositoryFake: EventsRepositoryInterface {
    var error: Error?
    var events: [Event] = []
    func getEvents() async throws -> [Eventorias.Event] {
        if let error = error {
            throw error
        }
        return events
    }
    
    func setEvent(_ event: Eventorias.Event) throws {
        if let error = error {
            throw error
        }
    }
    
    func deleteEvent(with id: String) {
        
    }
    
    func clearDB() async throws {
        if let error = error {
            throw error
        }
    }
}
