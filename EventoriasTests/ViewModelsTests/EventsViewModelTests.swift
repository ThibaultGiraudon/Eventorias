//
//  EventsViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest
@testable import Eventorias

@MainActor
final class EventsViewModelTests: XCTestCase {
    
    func testFetchEventsShouldSucceed() async {
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.events = FakeData().events
        
        let eventsVM = EventsViewModel(eventsRepository: eventsRepoFake)
        
        await eventsVM.fetchEvents()
        
        XCTAssertEqual(eventsVM.filteredEvents.count, 4)
        eventsVM.searchText = "Monaco"
        eventsVM.filterBy = .title
        XCTAssertEqual(eventsVM.filteredEvents, [FakeData().monaco])
        eventsVM.searchText = "Monza"
        eventsVM.filterBy = .description
        XCTAssertEqual(eventsVM.filteredEvents, [FakeData().monza])
        eventsVM.searchText = "Imola"
        eventsVM.filterBy = .address
        XCTAssertEqual(eventsVM.filteredEvents, [FakeData().imola])
        eventsVM.searchText = "Mon"
        eventsVM.filterBy = .title
        eventsVM.sortingBy = .ascending
        XCTAssertEqual(eventsVM.sortedEvents, [FakeData().monaco, FakeData().monza])
        eventsVM.sortingBy = .descending
        XCTAssertEqual(eventsVM.sortedEvents, [FakeData().monza, FakeData().monaco])
        
        XCTAssertEqual(SortingOrder.ascending.icon, "arrow.up")
        XCTAssertEqual(SortingOrder.descending.icon, "arrow.down")
    }
    
    func testFetchEventsShouldFailedWithError() async {
        let eventsRepositoryFake = EventsRepositoryFake()
        eventsRepositoryFake.error = URLError(.badURL)
        let eventsVM = EventsViewModel(eventsRepository: eventsRepositoryFake)
        
        await eventsVM.fetchEvents()
        XCTAssertEqual(eventsVM.error, "fetching events")
    }
    
    func testGenerateDayForMonth() {
        let eventsVM = EventsViewModel()
        
        guard let date = String("07/05/2025").toDate() else {
            XCTFail("Fails to create date")
            return
        }
        
        eventsVM.currentMonth = date
        
        let month = eventsVM.generateDayForMonth()
        
        guard let day = month.first else {
            XCTFail("Fails to get first day")
            return
        }
        
        XCTAssertEqual(day.getDay(), 1)
        XCTAssertEqual(day.toString(format: "MMMM"), "July")
    }
    
    func testGoToNextMonth() {
        let eventsVM = EventsViewModel()
        
        guard let date = String("07/05/2025").toDate() else {
            XCTFail("Fails to create date")
            return
        }
        
        eventsVM.currentMonth = date
        
        eventsVM.goToNextMonth()
        
        XCTAssertEqual(eventsVM.currentMonth.toString(format: "MMMM"), "August")
    }
    
    func testGoToPreviousMonth() {
        let eventsVM = EventsViewModel()
        
        guard let date = String("07/05/2025").toDate() else {
            XCTFail("Fails to create date")
            return
        }
        
        eventsVM.currentMonth = date
        
        eventsVM.goToPreviousMonth()
        
        XCTAssertEqual(eventsVM.currentMonth.toString(format: "MMMM"), "June")
    }
    
    func testGoToNow() {
        let eventsVM = EventsViewModel()
        
        guard let date = String("07/05/2025").toDate() else {
            XCTFail("Fails to create date")
            return
        }
        
        eventsVM.currentMonth = date
        
        eventsVM.goToNow()
        
        XCTAssertEqual(eventsVM.currentMonth.stripTime(), .now.stripTime())
    }
    
    func testGetEvent() {
        let eventsVM = EventsViewModel()
        let event = Event(
              title: "title",
              descrition: "description",
              date: .now,
              hour: .now,
              imageURL: "",
              address: "",
              location: .init(latitude: 0, longitude: 0),
              creatorID: ""
             )
        eventsVM.events = [event]
        
        XCTAssertEqual(eventsVM.getEvents(for: .now), [event])
    }
}
