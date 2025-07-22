//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 22/07/2025.
//

import SwiftUI
import Kingfisher
import MapKit

struct EventDetailView: View {
    var event: Event
    @StateObject var eventVM: EventViewModel
    init(event: Event) {
        self.event = event
        self._eventVM = StateObject(wrappedValue: EventViewModel(event: event))
    }
    
    var body: some View {
        ScrollView {
            KFImage(URL(string: event.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 22)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                        Text(event.date.toString(format: "MMMM dd, yyyy"))
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(event.hour.toString(format: "HH:mm a"))
                    }
                }
                .font(.title3)
                
                Spacer()
                
                KFImage(URL(string: eventVM.creator.imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .clipShape(Circle())
            }
            
            Text(event.descrition)
                .padding(.vertical, 22)
            
            GeometryReader { proxy in
                HStack {
                    Text(event.address)
                        .font(.title3)
                    Spacer()
                    Map(position: $eventVM.position) { 
                        Marker("", coordinate: eventVM.location.coordinate)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(width: proxy.size.width / 2)
                }
            }
            .frame(height: 100)
        }
        .padding()
        .foregroundStyle(.white)
        .background {
            Color("background")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    EventDetailView(event: Event(
        title: "Art exhibition",
        descrition: "Join us for an exclusive Art Exhibition showcasing the works of the talented artist Emily Johnson. This exhibition will feature a captivating collection of her contemporary and classical pieces, offering a unique insight into her creative journey. Whether you're an art enthusiast or a casual visitor, you'll have the chance to explore a diverse range of artworks.",
        date: "07/20/2024".toDate() ?? .now,
        hour: "10:00".toHour() ?? .now,
        imageURL: "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/events%2FEvent%20photo.png?alt=media&token=d8aaf643-c971-46f6-b3b2-e92a34f8356c",
        address: "123 Rue de l'Art, Quartier des Galeries, Paris, 75003, France",
        location: .init(latitude: 48.875226, longitude: 2.303139),
        creatorID: "123"))
}
