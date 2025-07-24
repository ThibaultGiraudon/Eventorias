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
                customButton(systemName: "chevron.right") {
                    eventsVM.goToNextMonth()
                }
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
                        }
                }
            }
            
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
    }
}

#Preview {
    EventsCalendarView(eventsVM: EventsViewModel())
}
