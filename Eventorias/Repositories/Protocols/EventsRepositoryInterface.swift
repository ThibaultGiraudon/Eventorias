//
//  EventsRepositoryInterface.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 23/07/2025.
//

import Foundation

protocol EventsRepositoryInterface {
    func getEvents() async throws -> [Event]
    func setEvent(_ event: Event) throws
    func deleteEvent(with id: String)
    func clearDB() async throws
}
