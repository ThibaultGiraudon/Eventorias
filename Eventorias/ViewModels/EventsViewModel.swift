//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var searchText: String = ""
    @Published var sortingBy: SortingOrder = .ascending
    @Published var filterBy: FilterType = .date
    var filteredEvents: [Event] {
        events.filter { event in
            if searchText.isEmpty {
                return true
            }
            switch filterBy {
            case .title:
                return event.title.contains(searchText)
            case .description:
                return event.descrition.contains(searchText)
            case .date:
                return event.date.toString(format: "MM/dd/yyyy").contains(searchText)
            case .address:
                return event.address.contains(searchText)
            }
        }
    }
    var sortedEvents: [Event] {
        filteredEvents.sorted {
            switch sortingBy {
            case .ascending:
                return $0.date > $1.date
            case .descending:
                return $0.date < $1.date
            }
        }
    }
    
    private let eventsRepository: EventsRepository = .init()
    
    init() {
        Task {
            await self.fetchEvents()
        }
    }
    
    func fetchEvents() async {
        do {
            events = try await eventsRepository.getEvents()
            print(events)
        } catch {
            print(error)
        }
    }
    
    private func makeComparator<T: Comparable>(ascending: Bool) -> (T, T) -> Bool {
        return ascending ? (<) : (>)
    }
}

enum FilterType: String, CaseIterable {
    case title = "Title"
    case description = "Description"
    case date = "Date"
    case address = "Address"
}

enum SortingOrder: String, CaseIterable {
    case ascending, descending
    
    var icon: String {
        switch self {
        case .ascending:
            "arrow.up"
        case .descending:
            "arrow.down"
        }
    }
}
