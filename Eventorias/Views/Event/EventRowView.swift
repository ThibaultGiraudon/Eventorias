//
//  EventRowView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI
import Kingfisher

struct EventRowView: View {
    var event: Event
    @StateObject var eventVM: EventViewModel
    @State private var creator: User = .init()
    init(event: Event) {
        self.event = event
        self._eventVM = StateObject(wrappedValue: EventViewModel(event: event, session: UserSessionViewModel()))
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: creator.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipped()
                .clipShape(Circle())
                .padding(.leading)
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.title3)
                Text(event.date.toString(format: "MMMM dd, yyyy"))
            }
            Spacer()
            KFImage(URL(string: event.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 136, height: 80)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
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
