//
//  UserSessionViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest
import SwiftUI
@testable import Eventorias

@MainActor
final class UserSessionViewModelTests: XCTestCase {
    
    func testLoadUserShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        userRepoFake.user = FakeData().user
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.events = FakeData().events
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertTrue(session.isLoggedIn)
        XCTAssertEqual(session.currentUser?.fullname, "Charles Leclerc")
        XCTAssertEqual(session.createdEvents.count, 2)
        XCTAssertEqual(session.subscribedEvents.count, 4)
    }
    
    func testLoadUserShouldFailedWithErrorInUserRepo() async {
        let userRepoFake = UserRepositoryFake()
        userRepoFake.error = FakeData().error
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.events = FakeData().events
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertNil(session.currentUser)
        XCTAssertEqual(session.error, "retreiving personnal information")
    }
    
    func testLoadUserShouldFailedWithErrorInEventsRepo() async {
        let userRepoFake = UserRepositoryFake()
        userRepoFake.user = FakeData().user
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertNil(session.currentUser)
        XCTAssertEqual(session.error, "retreiving personnal information")
    }
    
    func testLoadUserShouldFailedWithNoUser() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertNil(session.currentUser)
        XCTAssertEqual(session.error, "retreiving personnal information")
    }
    
    func testUpdateUserShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        let authRepoFake = AuthenticationRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, authRepository: authRepoFake)
        session.currentUser = FakeData().user
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.currentUser?.email, "pierre.gasly@alpine.fr")
        XCTAssertEqual(session.currentUser?.fullname, "Pierre Gasly")
    }
    
    func testUpdateUserShouldFailedWithUserNotLogged() async {
        let userRepoFake = UserRepositoryFake()
        let authRepoFake = AuthenticationRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, authRepository: authRepoFake)
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    func testUpdateUserShouldFailedWithError() async {
        let userRepoFake = UserRepositoryFake()
        let authRepoFake = AuthenticationRepositoryFake()
        authRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, authRepository: authRepoFake)
        session.currentUser = FakeData().user
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, "updating user's personnal information")
    }
    
    func testUploadImageShouldSucceed() async {
        let storageRepoFake = StorageRepositoryFake()
        storageRepoFake.imageURL = FakeData().imageURL
        let userRepoFake = UserRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, storageRepository: storageRepoFake)
        session.currentUser = FakeData().user
        session.currentUser?.imageURL = "https://newtest.fr"
        
        await session.uploadImage(UIImage())
        XCTAssertEqual(session.currentUser?.imageURL, FakeData().imageURL)
    }
    
    func testUploadImageShouldFailedWithError() async {
        let userRepoFake = UserRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        storageRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, storageRepository: storageRepoFake)
        session.currentUser = FakeData().user
        
        await session.uploadImage(UIImage())
        
        XCTAssertEqual(session.error, "uploading new user's profile picture")
    }
    
    func testUploadImageShouldFailedWithUserNotLogged() async {
        let userRepoFake = UserRepositoryFake()
        let storageRepoFake = StorageRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, storageRepository: storageRepoFake)
        
        await session.uploadImage(UIImage())
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    func testAddEventShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        
        await session.addEvent(FakeData().createdEvent, to: .created)
        await session.addEvent(FakeData().subscribedEvent, to: .subscribed)
        
        guard let createdEvent = session.currentUser?.createdEvents.first else {
            XCTFail("Failed to get first created event")
            return
        }
        guard let subscribedEvent = session.currentUser?.subscribedEvents.first else {
            XCTFail("Failed to get first created event")
            return
        }
        
        XCTAssertEqual(createdEvent, FakeData().createdEvent.id)
        XCTAssertEqual(subscribedEvent, FakeData().subscribedEvent.id)
    }
    
    func testAddEventShouldFailedWithUserNotLogged() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.addEvent(FakeData().createdEvent, to: .created)
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    func testAddEventShouldFailedWithError() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        
        await session.addEvent(FakeData().createdEvent, to: .created)
        
        XCTAssertEqual(session.error, "subscribing to the event")
    }
    
    func testRemoveEventShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        session.currentUser?.subscribedEvents = [FakeData().subscribedEvent.id]
        
        await session.removeEvent(FakeData().subscribedEvent)
        
        XCTAssertEqual(session.currentUser?.subscribedEvents, [])
    }
    
    func testRemoveEventShouldFailedWithError() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        session.currentUser?.subscribedEvents = [FakeData().subscribedEvent.id]
        
        await session.removeEvent(FakeData().subscribedEvent)
        
        XCTAssertEqual(session.error, "unsubscribing to the event")
    }
    
    func testRemoveEventShouldFailedWithUserNotLogged() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        eventsRepoFake.error = FakeData().error
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        
        await session.removeEvent(FakeData().subscribedEvent)
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    func testLogOut() {
        let session = UserSessionViewModel()
        session.logout()
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
    }
}
