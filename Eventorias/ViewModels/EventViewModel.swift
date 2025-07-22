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
    var creator: User {
        getUser()
    }
    
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
    
    func getUser() -> User {
        var user = User(uid: "", email: "unknow", fullname: "unknow", imageURL: nil)
        Task {
            guard let fetchedUser = try await userRepository.getUser(withId: event.creatorID) else {
                return user
            }
            user = fetchedUser
            return user
        }
        return user
    }
}
