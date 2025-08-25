//
//  AddEventViewModelTests.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest
import MapKit
@testable import Eventorias

@MainActor
final class AddEventViewModelTests: XCTestCase {
    
    func testShouldDisable() async {
        let session = UserSessionViewModel()
        session.currentUser = FakeData().user
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.title = "title"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.description = "description"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.date = "08/17/2003".toDate() ?? .now
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.hour = "10:00".toDate() ?? .now
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.address = "ici"
        XCTAssertTrue(viewModel.shouldDisable)
        viewModel.uiImage = UIImage()
        XCTAssertFalse(viewModel.shouldDisable)
    }
    
    func testAddEventShouldSucceed() async {
        let session = UserSessionViewModel()
        session.currentUser = FakeData().user
        let eventsRepoFake = EventsRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        let viewModel = AddEventViewModel(
            session: session,
            eventsRepository: eventsRepoFake,
            storageRepository: storageRepoFake,
            geocoder: CLGeocoderFake())
        
        viewModel.title = "uniquetitle"
        viewModel.description = "description"
        viewModel.date = "08/17/2003".toDate() ?? .now
        viewModel.hour = "10:00".toDate() ?? .now
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()

        XCTAssertNil(viewModel.session.error)
    }
    
    func testAddEventShouldFailedWithNoCoordinate() async {
        let session = UserSessionViewModel()
        session.currentUser = FakeData().user
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003".toDate() ?? .now
        viewModel.hour = "10:00".toDate() ?? .now
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "Failed to get address.")
    }
    
    func testAddEventShouldFailedWithNoUIImage() async {
        let session = UserSessionViewModel()
        session.currentUser = FakeData().user
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003".toDate() ?? .now
        viewModel.hour = "10:00".toDate() ?? .now
        viewModel.address = "123 Rue de l'Art, Quartier des Galeries, Paris, 75003, France"
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "Can't find image.")
    }
    
    func testAddEventShouldFailedWithNoUser() async {
        let session = UserSessionViewModel()
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003".toDate() ?? .now
        viewModel.hour = "10:00".toDate() ?? .now
        viewModel.address = "ici"
        viewModel.uiImage = loadImage(named: "charles-leclerc.jpg")
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        
        await viewModel.addEvent()
        
        XCTAssertEqual(viewModel.error, "User not logged in.")
    }

    func testAddEventShouldFailedWithBadURL() async {
        let session = UserSessionViewModel()
        session.currentUser = FakeData().user
        let viewModel = AddEventViewModel(session: session, geocoder: CLGeocoderFake())
        
        viewModel.title = "title"
        viewModel.description = "description"
        viewModel.date = "08/17/2003".toDate() ?? .now
        viewModel.hour = "10:00".toDate() ?? .now
        viewModel.address = "ici"
        viewModel.location = Location(coordinate: .init(latitude: 0, longitude: 0))
        viewModel.uiImage = UIImage()
        
        await viewModel.addEvent()
        
        XCTAssertEqual(session.error, "creating a new event")
    }
    
    func testGeocodeAddressShouldSucceed() async {
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
    
    func testGeocodeAddressShouldFailedWithEmptyPlacemark() async {
        let geocoderFake = CLGeocoderFake()
        let viewModel = AddEventViewModel(session: UserSessionViewModel(), geocoder: geocoderFake)
        viewModel.address = ""
        await viewModel.geocodeAddress()
        
        XCTAssertEqual(viewModel.error, "Failed to find address")
    }
    
    func testGeocodeAddressShouldFailedWithError() async {
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
