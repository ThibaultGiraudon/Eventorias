//
//  CalendarDayView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 24/07/2025.
//

import SwiftUI

struct CalendarDayView: View {
    var date: Date
    @ObservedObject var eventsVM: EventsViewModel
    var body: some View {
        VStack {
            Text("\(date.getDay())")
                .font(.title3)
            Spacer()
            if !eventsVM.getEvents(for: date).isEmpty {
                Circle()
                    .fill(.blue.opacity(0.8))
                    .frame(width: 10)
            }
        }
        .padding(5)
        .frame(height: 50)
    }
}

#Preview {
    CalendarDayView(date: .now, eventsVM: EventsViewModel())
}
