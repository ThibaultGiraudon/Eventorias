//
//  EventsRepositoryTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import XCTest
@testable import Eventorias

final class EventsRepositoryTests: XCTestCase {

    var eventsRepository: EventsRepository!
    override func setUp() {
        super.setUp()
        
        eventsRepository = EventsRepository()
    }

    override func tearDown() {
        eventsRepository = nil
        super.tearDown()
    }

    func testSetAndGetAndDeleteEventShouldSucceed() async {
        let event = Event(title: "title",
                          descrition: "description",
                          date: .now,
                          hour: .now,
                          imageURL: "",
                          address: "ici",
                          location: .init(latitude: 0, longitude: 0),
                          creatorID: "123")
        
        do {
            try eventsRepository.setEvent(event)
            var events = try await eventsRepository.getEvents()
            XCTAssertEqual(events.count, 1)
            eventsRepository.deleteEvent(with: event.id)
            events = try await eventsRepository.getEvents()
            XCTAssertTrue(events.isEmpty)
        } catch {
            XCTFail("Operation should not fails")
        }
    }
}
