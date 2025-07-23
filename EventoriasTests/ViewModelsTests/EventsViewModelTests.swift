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
        do {
            try await EventsRepository().clearDB()
        } catch {
            XCTFail("fail")
        }
        
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
}
