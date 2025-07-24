//
//  EventsViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 22/07/2025.
//

import XCTest
@testable import Eventorias

final class EventsViewModelTests: XCTestCase {
    
    func testFetchEventsShouldSucceed() async {        
        let events: [Event] = [
            Event(
                  title: "Grand Prix Belgique",
                  descrition: "Grand Prix Belgique",
                  date: "27/27/2025".toDate() ?? .now,
                  hour: .now,
                  imageURL: "",
                  address: "Circuit de Spa-Francorchamps",
                  location: .init(latitude: 0, longitude: 0),
                  creatorID: "123"
            ),
            Event(
                  title: "Grand Prix Hongrie",
                  descrition: "Grand Prix Hongrie",
                  date: "08/08/2025".toDate() ?? .now,
                  hour: .now,
                  imageURL: "",
                  address: "Hungaroring utca 10, Mogyorod 2146 Hongrie",
                  location: .init(latitude: 0, longitude: 0),
                  creatorID: "123"
            )
            ]
        
        do {
            for event in events {
                try EventsRepository().setEvent(event)
            }
            let viewModel = EventsViewModel()
            
            await viewModel.fetchEvents()
            
            print(viewModel.events)
            
            viewModel.filterBy = .title
            viewModel.searchText = "Grand Prix"
            XCTAssertEqual(viewModel.filteredEvents.count, 2)
            
            viewModel.filterBy = .description
            viewModel.searchText = "Belgique"
            XCTAssertEqual(viewModel.filteredEvents.count, 1)
            
            viewModel.filterBy = .date
            viewModel.searchText = "07/"
            XCTAssertEqual(viewModel.filteredEvents.count, 1)
            
            viewModel.filterBy = .address
            viewModel.searchText = "Spa"
            XCTAssertEqual(viewModel.filteredEvents.count, 1)
            
            viewModel.searchText = ""
            viewModel.sortingBy = .ascending
            XCTAssert(viewModel.sortedEvents[0].date < viewModel.sortedEvents[1].date)
            
            viewModel.sortingBy = .descending
            XCTAssert(viewModel.sortedEvents[0].date > viewModel.sortedEvents[1].date)
            
            XCTAssertEqual(SortingOrder.ascending.icon, "arrow.up")
            XCTAssertEqual(SortingOrder.descending.icon, "arrow.down")
        } catch {
            XCTFail("An error occured: \(error)")
        }
    }
    
    @MainActor
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
        let event = Event(title: "title",
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
