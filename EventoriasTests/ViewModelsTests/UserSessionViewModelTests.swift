//
//  UserSessionViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import XCTest
@testable import Eventorias
import FirebaseAuth

final class UserSessionViewModelTests: XCTestCase {
    
    func testUserShouldSucceed() {
        let user = User()
        
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.fullname, "")
        XCTAssertEqual(user.imageURL, user.defaultImage)
    }
    
    @MainActor
    func testLoadUserShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        guard let user = session.currentUser else {
            XCTFail("Current User should not be nil")
            return
        }
        
        XCTAssertEqual(user.fullname, "Charles Leclerc")
        XCTAssertTrue(session.isLoggedIn)
    }

    @MainActor
    func testLoadUserShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.error = URLError(.badURL)
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertEqual(session.error, "retreiving personnal information")
    }
    
    @MainActor
    func testLoadUserShouldFailedWithUserNotFound() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertEqual(session.error, "retreiving personnal information")
    }
    
    @MainActor
    func testUpdateUserShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        guard let user = session.currentUser else {
            XCTFail("Current user should not be nil")
            return
        }
        XCTAssertEqual(user.fullname, "Pierre Gasly")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithNotLoggedIn() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = URLError(.badURL)
        let userRepositoryFake = UserRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        session.currentUser = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, "updating user's personnal information")
    }
    
    @MainActor
    func testUploadImageShouldSucceed() async {
        guard let image = loadImage(named: "charles-leclerc.jpg") else {
            XCTFail("Failed to load image")
            return
        }
        
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        do {
            try await Auth.auth().createUser(withEmail: "testUserVM@test.app", password: "123456")
        } catch {
            XCTFail("Failed to create user")
        }
        
        await session.loadUser(by: "123")
        await session.uploadImage(image)
        XCTAssertNotEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        await session.uploadImage(image)
    }
    
    @MainActor
    func testUploadImageShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        let image = UIImage()
        
        await session.loadUser(by: "123")
        await session.uploadImage(image)
        XCTAssertEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        XCTAssertEqual(session.error, "uploading new user's profile picture")
    }
    
    @MainActor
    func testUploadImageShouldFailedWithUserNotLogged() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        let image = UIImage()
        
        await session.uploadImage(image)
        XCTAssertEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testLogout() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        guard let user = session.currentUser else {
            XCTFail("Current User should not be nil")
            return
        }
        
        XCTAssertEqual(user.fullname, "Charles Leclerc")
        XCTAssertTrue(session.isLoggedIn)
        
        session.logout()
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
    }
    
    @MainActor
    func testAddEventShouldFailedUserNotLogged() async {
        let session = UserSessionViewModel()
        
        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: ""
        )
        
        await session.addEvent(event, to: .created)
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testaddEventShouldFailedWithError() async {
        let eventsRepositoryFake = EventsRepositoryFake()
        eventsRepositoryFake.error = URLError(.badURL)
        let session = UserSessionViewModel(eventsRepository: eventsRepositoryFake)
        session.currentUser = User()

        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: ""
        )
        
        await session.addEvent(event, to: .created)
        
        XCTAssertEqual(session.error, "subscribing to the event")
    }
    
    @MainActor
    func testRemoveEventShouldFailedWithUserNotLogged() async {
        let session = UserSessionViewModel()

        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: ""
        )
        
        await session.removeEvent(event)
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testRemoveEventShouldFailedWithError() async {
        let eventsRepositoryFake = EventsRepositoryFake()
        eventsRepositoryFake.error = URLError(.badURL)
        let session = UserSessionViewModel(eventsRepository: eventsRepositoryFake)
        session.currentUser = User()

        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: ""
        )

        session.currentUser?.subscribedEvents.append(event.id)
        await session.removeEvent(event)
        
        XCTAssertEqual(session.error, "unsubscribing to the event")
    }
    
    @MainActor
    func testEventsWithLoggedUser() {
        var events: [Event] = []
        
        let createdEvent1 = Event(
            id: "2003",
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "678"
        )
        let createdEvent2 = Event(
            id: "2004",
            title: "",
            descrition: "",
            date: .now + 86400,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "678"
        )
        let subscribedEvent1 = Event(
            id: "2005",
            title: "",
            descrition: "",
            date: .now + 86400,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "789",
            participants: ["678"]
        )
        let subscribedEvent2 = Event(
            id: "2006",
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "789",
            participants: ["678"]
        )
        events.append(createdEvent1)
        events.append(createdEvent2)
        events.append(subscribedEvent1)
        events.append(subscribedEvent2)
        
        let session = UserSessionViewModel(events: events)
        session.currentUser = User(uid: "678", email: "", fullname: "", imageURL: nil)
        
        XCTAssertEqual(session.createdEvents, [createdEvent2, createdEvent1])
        XCTAssertEqual(session.subscribedEvents, [subscribedEvent1, subscribedEvent2])
    }
    
    @MainActor
    func testEventsWithOutLoggedUser() {
        var events: [Event] = []
        
        let createdEvent1 = Event(
            id: "2003",
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "678"
        )
        let subscribedEvent1 = Event(
            id: "2004",
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "789",
            participants: ["678"]
        )
        events.append(createdEvent1)
        events.append(subscribedEvent1)
        
        let session = UserSessionViewModel(events: events)
        
        XCTAssertEqual(session.createdEvents, [])
        XCTAssertEqual(session.subscribedEvents, [])
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
