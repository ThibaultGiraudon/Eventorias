//
//  AddEventViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import SwiftUI
import MapKit

struct Location: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

class AddEventViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: String = ""
    @Published var hour: String = ""
    @Published var address: String = ""
    @Published var uiImage: UIImage?
    @Published var error: String?
    @Published var location: Location?
    @Published var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    )
    
    var shouldDisable: Bool {
        title.isEmpty || description.isEmpty || date.isEmpty || hour.isEmpty || address.isEmpty || uiImage == nil
    }

    private let eventRepository: EventsRepository = .init()
    private let storageRepository: StorageRepository = .init()
    private let session: UserSessionViewModel
    
    init(session: UserSessionViewModel) {
        self.session = session
    }
    
    @MainActor
    func addEvent() async {
        self.error = nil
        guard let date = self.date.toDate(), let hour = self.hour.toHour() else {
            self.error = "Bad date format."
            print("date error")
            return
        }
        
        guard let coordinate = location?.coordinate else {
            self.error = "Failed to get address"
            return
        }
        
        guard let uiImage = self.uiImage else {
            self.error = "Can't find image."
            print("image error")
            return
        }
        
        guard let user = session.currentUser else {
            self.error = "User not logged in."
            print("user error")
            return
        }
        
        do {
            let url = try await storageRepository.uploadImage(uiImage, to: "events")
            let event = Event(title: title,
                              descrition: description,
                              date: date,
                              hour: hour,
                              imageURL: url,
                              address: address,
                              location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude),
                              creatorID: user.uid)
            try eventRepository.setEvent(event)
            session.addEvent(event, to: .created)
        } catch {
            self.error = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func geocodeAddress() async {
        do {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.geocodeAddressString(address)
            guard let placemark = placemarks.first, let location = placemark.location else {
                self.error = "Failed to find address"
                return
            }
            let newCoordinate = location.coordinate
            self.location = Location(coordinate: .init(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude))
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            self.position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            )
        } catch {
            self.error = "Failed to find address"
        }
    }
}
