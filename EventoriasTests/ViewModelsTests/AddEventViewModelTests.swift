//
//  AddEventViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 22/07/2025.
//

import XCTest
@testable import Eventorias
import CoreLocation
import MapKit

final class AddEventViewModelTests: XCTestCase {
    
    @MainActor
    func testShouldDisable() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.title = "title"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.description = "description"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.date = "08/17/2003"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.hour = "10:00"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.address = "ici"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.uiImage = UIImage()
        XCTAssertFalse(viewModel.shouldDisable)
    }
    
    @MainActor
    func testAddEventShouldSucceed() async {
        do {
            try await EventsRepository().clearDB()
            let session = UserSessionViewModel()
            session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
            let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
            
            viewModel.title = "title"
            viewModel.description = "description"
            viewModel.date = "08/17/2003"
            viewModel.hour = "10:00"
            viewModel.address = "ici"
            viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
            viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
            
            await viewModel.addEvent()
            let eventsVM = EventsViewModel()
            await eventsVM.fetchEvents()
            guard let event = eventsVM.events.first else {
                XCTFail("Failed to get event")
                return
            }
            XCTAssertEqual(event.title, "title")
            XCTAssertEqual(event.descrition, "description")
            XCTAssertEqual(event.date.toString(format: "MM/dd/yyy"), "08/17/2003")
        } catch {
            XCTFail("fail")
        }
    }
    
    @MainActor
    func testAddEventShouldFailedWithBadHourFormat() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003"
        viewModel.hour = "test"
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "Bad date format.")
    }
    
    @MainActor
    func testAddEventShouldFailedWithNoCoordinate() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003"
        viewModel.hour = "10:00"
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "Failed to get address")
    }
    
    @MainActor
    func testAddEventShouldFailedWithNoUIImage() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003"
        viewModel.hour = "10:00"
        viewModel.address = "123 Rue de l'Art, Quartier des Galeries, Paris, 75003, France"
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "Can't find image.")
    }
    
    @MainActor
    func testAddEventShouldFailedWithNoUser() async {
        let session = UserSessionViewModel()
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003"
        viewModel.hour = "10:00"
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "User not logged in.")
    }

    @MainActor
    func testAddEventShouldFailedWithBadURL() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "user@test.com", fullname: "User Test", imageURL: nil)
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003"
        viewModel.hour = "10:00"
        viewModel.address = "ici"
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        viewModel.uiImage = UIImage()
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, URLError(.badURL).localizedDescription)
    }
    
    @MainActor
    func testGeocodeAddreesShouldSucceed() async {
        let geocodeFake = CLGeocoderFake()
        geocodeFake.placemarks = [MKPlacemark(coordinate: .init(latitude: 48.8654067, longitude: 2.3388291))]
        let viewModel = AddEventViewModel(session: UserSessionViewModel(), geocoder: geocodeFake)
        viewModel.address = "123 Rue de l’Art, Quartier des Galeries, Paris, 75003, France"
        await viewModel.geocodeAddress()
        
        guard let location = viewModel.location else {
            XCTFail("Failed to get location")
            return
        }
        
        XCTAssertEqual(location.coordinate.latitude, 48.8654067)
        XCTAssertEqual(location.coordinate.longitude, 2.3388291)
    }
    
    @MainActor
    func testGeocodeAddreesShouldFailedWithEmptyPlacemark() async {
        let geocoderFake = CLGeocoderFake()
        let viewModel = AddEventViewModel(session: UserSessionViewModel(), geocoder: geocoderFake)
        viewModel.address = ""
        await viewModel.geocodeAddress()
        
        XCTAssertEqual(viewModel.error, "Failed to find address")
    }
    
    @MainActor
    func testGeocodeAddreesShouldFailedWithError() async {
        let geocoderFake = CLGeocoderFake()
        geocoderFake.error = URLError(.badURL)
        let viewModel = AddEventViewModel(session: UserSessionViewModel(), geocoder: geocoderFake)
        viewModel.address = ""
        await viewModel.geocodeAddress()
        
        XCTAssertEqual(viewModel.error, "Failed to find address")
    }

    func loadImage(named name: String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
