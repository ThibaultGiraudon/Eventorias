//
//  EventsCalendarView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 24/07/2025.
//

import SwiftUI

struct EventsCalendarView: View {
    @ObservedObject var eventsVM: EventsViewModel
    @State private var selectedDay: Date = .now
    
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(eventsVM.currentMonth.toString(format: "MMMM, yyyy"))
                    .font(.title)
                Spacer()
                customButton(systemName: "chevron.left") {
                    eventsVM.goToPreviousMonth()
                }
                .accessibilityLabel("Previous month button")
                .accessibilityHint("Double-tap to go to previous month")
                Button {
                    eventsVM.goToNow()
                } label: {
                    Text("Today")
                        .font(.title2)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("CustomGray"))
                        }
                }
                .accessibilityLabel("Current month button")
                .accessibilityHint("Double-tap to go to current month")
                customButton(systemName: "chevron.right") {
                    eventsVM.goToNextMonth()
                }
                .accessibilityLabel("Next month button")
                .accessibilityHint("Double-tap to go to next month")
            }
            LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
                ForEach(eventsVM.generateDayForMonth(), id: \.self) { day in
                    CalendarDayView(date: day, eventsVM: eventsVM)
                        .foregroundStyle(selectedDay == day ? .black : .white)
                        .background {
                            if selectedDay == day {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                            } else if day.stripTime() == .now.stripTime() {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color("CustomGray"))
                            }
                        }
                        .onTapGesture {
                            selectedDay = day
                            UIAccessibility.post(notification: .announcement, argument: "There are \(eventsVM.getEvents(for: day).count) events for that day")
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityValue("\(day.toString(format: "dd MMMM")), \(eventsVM.getEvents(for: day).count) event")
                        .accessibilityHint("Double-tap to get events for the day")
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Calendar of events")
            
            ScrollView {
                if eventsVM.getEvents(for: selectedDay).isEmpty {
                    ContentUnavailableView("There are no events", systemImage: "calendar.badge.minus")
                } else {
                    ForEach(eventsVM.getEvents(for: selectedDay), id: \.self) { event in
                        EventRowView(event: event)
                            .onTapGesture {
                                coordinator.goToDetailView(for: event)
                            }
                    }
                }
            }
        }
        .padding()
        .foregroundStyle(.white)
        .background {
            Color("background")
                .ignoresSafeArea()
        }
        .dynamicTypeSize(.xSmall ... .xxLarge)
    }
    
    func customButton(systemName image: String, completion: @escaping () -> Void) -> some View {
        Button {
            completion()
        } label: {
            Image(systemName: image)
                .font(.title2)
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("CustomGray"))
                }
        }
        .accessibilityElement(children: .ignore)
    }
}

#Preview {
    EventsCalendarView(eventsVM: EventsViewModel())
}
