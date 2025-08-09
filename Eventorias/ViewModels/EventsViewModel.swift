//
//  EventsViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = true
    @Published var searchText: String = ""
    @Published var sortingBy: SortingOrder = .ascending
    @Published var filterBy: FilterType = .title
    @Published var error: String?
    @Published var currentMonth: Date = .now
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
            case .address:
                return event.address.contains(searchText)
            }
        }
    }
    var sortedEvents: [Event] {
        filteredEvents.sorted {
            switch sortingBy {
            case .ascending:
                return $0.date < $1.date
            case .descending:
                return $0.date > $1.date
            }
        }
    }
    
    private var calendar = Calendar.current
    
    private let eventsRepository: EventsRepositoryInterface
    
    init(eventsRepository: EventsRepositoryInterface = EventsRepository()) {
        self.eventsRepository = eventsRepository
        self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }
    
    @MainActor
    func fetchEvents() async {
        self.isLoading = true
        self.error = nil
        do {
            events = try await eventsRepository.getEvents()
        } catch {
            self.error = "fetching events"
        }
        self.isLoading = false
    }
    
    func generateDayForMonth() -> [Date] {
        var month: [Date] = []
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return month }
        
        var currentDay = monthInterval.start
        
        while currentDay < monthInterval.end {
            month.append(currentDay)
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? .now
        }
        
        return month
    }
    
    func getEvents(for date: Date) -> [Event] {
        events.filter { event in
            event.date.stripTime() == date.stripTime()
        }
    }
    
    func goToNow() {
        self.currentMonth = .now
    }
    
    func goToNextMonth() {
        self.currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? .now
    }
    
    func goToPreviousMonth() {
        self.currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? .now
    }
}

enum FilterType: String, CaseIterable {
    case title = "Title"
    case description = "Description"
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
