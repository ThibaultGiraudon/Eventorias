//
//  AddEventViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import SwiftUI
import MapKit

// change with google map API

struct Location: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

protocol CLGeocoderInterface {
    func geocodeAddressString(_ address: String) async throws -> [CLPlacemark]
}

extension CLGeocoder: CLGeocoderInterface { }

class AddEventViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: String = ""
    @Published var hour: String = ""
    @Published var address: String = ""
    @Published var uiImage: UIImage?
    @Published var location: Location?
    @Published var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    )
    
    var shouldDisable: Bool {
        title.isEmpty || description.isEmpty || date.isEmpty || hour.isEmpty || address.isEmpty || uiImage == nil || isLoading
    }

    private let eventRepository: EventsRepository = .init()
    private let storageRepository: StorageRepository = .init()
    private let session: UserSessionViewModel
    private let geocoder: CLGeocoderInterface
    
    init(session: UserSessionViewModel, geocoder: CLGeocoderInterface = CLGeocoder()) {
        self.session = session
        self.geocoder = geocoder
    }
    
    @MainActor
    func addEvent() async {
        isLoading = true
        self.session.error = nil
        self.error = nil
        guard let date = self.date.toDate() else {
            self.error = "Bad date format (should be MM/DD/YYYY)."
            isLoading = false
            return
        }
        
        guard let hour = self.hour.toHour() else {
            self.error = "Bad hour format (should be HH:MM)."
            isLoading = false
            return
        }
                
        guard let coordinate = location?.coordinate else {
            self.error = "Failed to get address."
            isLoading = false
            return
        }
        
        guard let uiImage = self.uiImage else {
            self.error = "Can't find image."
            isLoading = false
            return
        }

        guard let user = session.currentUser else {
            self.error = "User not logged in."
            isLoading = false
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
            await session.addEvent(event, to: .created)
            await session.addEvent(event, to: .subscribed)
        } catch {
            self.session.error = "creating a new event"
            isLoading = false
        }
        self.location = nil
        self.title = ""
        self.date = ""
        self.hour = ""
        self.description = ""
        self.address = ""
        self.uiImage = nil
        isLoading = false
    }
    
    @MainActor
    func geocodeAddress() async {
        self.error = nil
        self.location = nil
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            guard let placemark = placemarks.first, let location = placemark.location else {
                self.error = "Failed to find address"
                self.location = nil
                return
            }
            let newCoordinate = location.coordinate
            self.location = Location(coordinate: .init(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude))
            self.position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            )
        } catch {
            self.location = nil
            self.error = "Failed to find address"
        }
    }
}
