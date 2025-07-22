//
//  EventViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import SwiftUI
import MapKit

class EventViewModel: ObservableObject {
    @Published var event: Event
    @Published var location: Location
    @Published var position: MapCameraPosition
//    @Published var creator: User = User()
    
    private let userRepository: UserRepository = .init()
    
    init(event: Event) {
        self.event = event
        self.location = Location(coordinate: .init(latitude: event.location.latitude, longitude: event.location.longitude))
        self.position = MapCameraPosition.region(
            MKCoordinateRegion(
             center: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude),
             span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        )
    }
    
    @MainActor
    func getUser(with id: String) async -> User {
        do {
            return try await userRepository.getUser(withId: id)
                ?? User(uid: "nil", email: "unknow", fullname: "unknow", imageURL: nil)
        } catch {
            print(error)
        }
        return User(uid: "nil", email: "unknow", fullname: "unknow", imageURL: nil)
    }
}
