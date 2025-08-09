//
//  EventViewModelTests.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest
@testable import Eventorias

@MainActor
final class EventViewModelTests: XCTestCase {
    
    func testGetUserShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        userRepoFake.user = FakeData().user
        
        let eventVM = EventViewModel(
            event: FakeData().monaco,
            session: UserSessionViewModel(),
            userRepository: userRepoFake
        )
        
        let user = await eventVM.getUser(with: "123")
        
        XCTAssertEqual(user, FakeData().user)
    }
    
    func testGetUserShouldFailedWithNoUser() async {
        let userRepoFake = UserRepositoryFake()
        
        let eventVM = EventViewModel(
            event: FakeData().monaco,
            session: UserSessionViewModel(),
            userRepository: userRepoFake
        )
        
        let user = await eventVM.getUser(with: "123")
        
        XCTAssertEqual(user.email, "unknow")
    }
    
    func testGetUserShouldFailedWithError() async {
        let userRepoFake = UserRepositoryFake()
        userRepoFake.error = FakeData().error
        
        let eventVM = EventViewModel(
            event: FakeData().monaco,
            session: UserSessionViewModel(),
            userRepository: userRepoFake
        )
        
        let user = await eventVM.getUser(with: "123")
        
        XCTAssertEqual(user.email, "unknow")
        XCTAssertEqual(eventVM.session.error, "getting event's owner")
    }
    
    func testAddEventShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        
        let eventVM = EventViewModel(event: FakeData().subscribedEvent, session: session)
        
        await eventVM.addEvent()
        
        guard let subscribedEvent = eventVM.session.currentUser?.subscribedEvents.first else {
            XCTFail("Failed to get first created event")
            return
        }
        
        XCTAssertEqual(subscribedEvent, FakeData().subscribedEvent.id)
    }
    
    func testRemoveEventShouldSucceed() async {
        let userRepoFake = UserRepositoryFake()
        let eventsRepoFake = EventsRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepoFake, eventsRepository: eventsRepoFake)
        session.currentUser = FakeData().user
        session.currentUser?.subscribedEvents = [FakeData().subscribedEvent.id]
        
        let eventVM = EventViewModel(event: FakeData().subscribedEvent, session: session)
        
        await eventVM.removeEvent()
        
        XCTAssertEqual(session.currentUser?.subscribedEvents, [])
    }
    
    func testIsSubscribeShouldBeTrue() {
        let session = UserSessionViewModel()
        session.currentUser = User(
            uid: "123",
            email: "charles.leclerc@ferrari.mc",
            fullname: "Charles Leclerc",
            imageURL: nil)
        var event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "")
        event.participants.append("123")
        session.currentUser?.subscribedEvents.append(event.id)
        
        let eventVM = EventViewModel(event: event, session: session)
        
        XCTAssertTrue(eventVM.isSubsribe)
    }
    
    func testIsSubscribeShouldBeFalse() {
        let session = UserSessionViewModel()
        session.currentUser = User(
            uid: "123",
            email: "charles.leclerc@ferrari.mc",
            fullname: "Charles Leclerc",
            imageURL: nil)
        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "")
        
        let eventVM = EventViewModel(event: event, session: session)
        
        XCTAssertFalse(eventVM.isSubsribe)
    }
    
    func testIsSubscribeShouldBeFalseWithNoUser() {
        let session = UserSessionViewModel()
        let event = Event(
            title: "",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "")
        
        let eventVM = EventViewModel(event: event, session: session)
        
        XCTAssertFalse(eventVM.isSubsribe)
    }
}
