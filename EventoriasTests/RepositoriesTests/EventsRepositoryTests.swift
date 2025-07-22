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
        let newEvent = Event(title: "title",
                          descrition: "description",
                          date: .now,
                          hour: .now,
                          imageURL: "",
                          address: "ici",
                          location: .init(latitude: 0, longitude: 0),
                          creatorID: "123")
        
        do {
            try eventsRepository.setEvent(newEvent)
            var events = try await eventsRepository.getEvents()
            guard let event = events.first(where: { $0.title == "title" }) else {
                XCTFail("Failed to get event")
                return
            }
            XCTAssertEqual(event.descrition, "description")
            try await eventsRepository.clearDB()
            events = try await eventsRepository.getEvents()
            XCTAssertEqual(events.count, 0)
        } catch {
            XCTFail("Operation should not fails")
        }
    }
}
