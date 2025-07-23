//
//  EventViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
class EventViewModel: ObservableObject {
    @Published var event: Event
    @Published var location: Location
    @Published var position: MapCameraPosition
    var isSubsribe: Bool {
        session.currentUser?.subscribedEvents.contains(event.id) ?? false
    }
    
    private let userRepository: UserRepository = .init()
    private let session: UserSessionViewModel
    
    init(event: Event, session: UserSessionViewModel) {
        self.event = event
        self.location = Location(coordinate: .init(latitude: event.location.latitude, longitude: event.location.longitude))
        self.position = MapCameraPosition.region(
            MKCoordinateRegion(
             center: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude),
             span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        )
        self.session = session
    }
    
    @MainActor
    func getUser(with id: String) async -> User {
        self.session.error = nil
        do {
            return try await userRepository.getUser(withId: id)
                ?? User(uid: "nil", email: "unknow", fullname: "unknow", imageURL: nil)
        } catch {
            self.session.error = "getting event's owner"
        }
        return User(uid: "nil", email: "unknow", fullname: "unknow", imageURL: nil)
    }
    
    @MainActor
    func addEvent() async {
        await session.addEvent(event, to: .subscribed)
    }
    
    @MainActor
    func removeEvent() async {
        await session.removeEvent(event)
    }
}
