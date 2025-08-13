//
//  EventsListView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI

struct EventsListView: View {
    @MainActor @ObservedObject var eventsVM: EventsViewModel
    
    @EnvironmentObject var coordinator: AppCoordinator
    @ScaledMetric var size = 18
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .accessibilityHidden(true)
                TextField(text: $eventsVM.searchText) {
                    Text("Search")
                        .foregroundStyle(.white)
                }
                Spacer()
                if !eventsVM.searchText.isEmpty {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            eventsVM.searchText = ""
                        }
                        .accessibilityLabel("Erase button")
                        .accessibilityHint("Double-tap to erase search text")
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                Capsule()
                    .fill(Color("CustomGray"))
            }
            
            HStack {
                HStack {
                    Image(systemName: eventsVM.sortingBy.icon)
                    Text("Sorting")
                }
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background {
                    Capsule()
                        .fill(Color("CustomGray"))
                }
                .onTapGesture {
                    if eventsVM.sortingBy == .ascending {
                        eventsVM.sortingBy = .descending
                    } else {
                        eventsVM.sortingBy = .ascending
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Sorting button")
                .accessibilityHint("Double-tap sort \(eventsVM.sortingBy == .ascending ? "descending" : "ascending")")
                
                Picker("Filter", selection: $eventsVM.filterBy) {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        Text(filter.rawValue)
                    }
                }
                .tint(.white)
                .padding(.vertical, 1)
                .padding(.horizontal, 8)
                .background {
                    Capsule()
                        .fill(Color("CustomGray"))
                }
                .accessibilityHint("Double-tap to change filter")
            }
            .padding(.bottom, 24)
            if eventsVM.isLoading {
                 LoadingView()
            } else {
                ScrollView(showsIndicators: false) {
                    if eventsVM.sortedEvents.isEmpty {
                        Text("No events yet")
                            .accessibilityIdentifier("emptyEventsMessage")
                            .foregroundStyle(.white)
                    } else {
                        ForEach(eventsVM.sortedEvents) { event in
                            EventRowView(event: event)
                                .onTapGesture {
                                    coordinator.goToDetailView(for: event)
                                }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await eventsVM.fetchEvents()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            Color("background")
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                coordinator.goToAddEvent()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("CustomRed"))
                    }
                    .padding()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Add button")
            .accessibilityHint("Double-tap to open form to add an event")
        }
        .onAppear {
            Task {
                await eventsVM.fetchEvents()
            }
        }
    }
}

#Preview {
    EventsListView(eventsVM: EventsViewModel())
}
