//
//  EventRowView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI

struct EventRowView: View {
    var event: Event
    @StateObject var eventVM: EventViewModel
    @State private var creator: User = .init()
    
    @ScaledMetric private var userImageSize = 40
    @ScaledMetric private var eventImageHeight = 80
    @ScaledMetric private var eventImageWidth = 136
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    init(event: Event) {
        self.event = event
        self._eventVM = StateObject(wrappedValue: EventViewModel(event: event, session: UserSessionViewModel()))
    }
    
    var body: some View {
        adaptiveStack {
            if dynamicTypeSize <= .xxLarge {
                FBImage(url: URL(string: creator.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: userImageSize, height: userImageSize)
                        .clipped()
                        .clipShape(Circle())
                        .padding(.leading)
                        .accessibilityElement()
                        .accessibilityLabel("Owner's image")
                }
            }
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.title3)
                Text(event.date.toString(format: "MMMM dd, yyyy"))
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Event's information")
            .accessibilityValue("\(event.title) the \(event.date.toString(format: "MMMM dd, yyyy"))")
            Spacer()
            FBImage(url: URL(string: event.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: eventImageWidth, height: eventImageHeight)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement()
                    .accessibilityLabel("Event's image")
            }
        }
        .foregroundStyle(.white)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CustomGray"))
        }
        .task {
            creator = await eventVM.getUser(with: event.creatorID)
        }
    }
    
    @ViewBuilder
    func adaptiveStack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if dynamicTypeSize > .xxLarge {
            VStack { content() }
                .frame(maxWidth: .infinity)
        } else {
            HStack { content() }
                .multilineTextAlignment(.leading)
        }
    }
    
}

#Preview {
    EventRowView(event: Event(
        title: "Art exhibition",
        descrition: "Join us for an exclusive Art Exhibition showcasing the works of the talented artist Emily Johnson. This exhibition will feature a captivating collection of her contemporary and classical pieces, offering a unique insight into her creative journey. Whether you're an art enthusiast or a casual visitor, you'll have the chance to explore a diverse range of artworks.",
        date: "07/20/2024".toDate() ?? .now,
        hour: "10:00".toDate() ?? .now,
        imageURL: "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/events%2FEvent%20photo.png?alt=media&token=d8aaf643-c971-46f6-b3b2-e92a34f8356c",
        address: "123 Rue de l'Art, Quartier des Galeries, Paris, 75003, France",
        location: .init(latitude: 48.875226, longitude: 2.303139),
        creatorID: "123"))
}
