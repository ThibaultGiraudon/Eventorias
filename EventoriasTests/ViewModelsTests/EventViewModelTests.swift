//
//  EventViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 22/07/2025.
//

import XCTest
@testable import Eventorias

final class EventViewModelTests: XCTestCase {
    
    @MainActor
    func testGetUserShouldSucceed() async {
        let userRepository = UserRepository()
        let user = User(uid: UUID().uuidString, email: "isack.hadjar@vcarb.fr", fullname: "Isack Hadjar", imageURL: nil)
        userRepository.setUser(user)
        let viewModel = EventViewModel(
            event: Event(
                    title: "Grand Prix Belgique",
                    descrition: "Grand Prix Belgique",
                    date: "27/27/2025".toDate() ?? .now,
                    hour: .now,
                    imageURL: "",
                    address: "Circuit de Spa-Francorchamps",
                    location: .init(latitude: 0, longitude: 0),
                    creatorID: user.uid),
            session: UserSessionViewModel())
        let creator = await viewModel.getUser(with: user.uid)
        XCTAssertEqual(creator.email, "isack.hadjar@vcarb.fr")
    }
    
    @MainActor
    func testGetUserShouldFailed() async {
        let userRepository = UserRepository()
        userRepository.setData([:], id: "unautresuperid")
        let viewModel = EventViewModel(
            event: Event(
                    title: "Grand Prix Belgique",
                    descrition: "Grand Prix Belgique",
                    date: "27/27/2025".toDate() ?? .now,
                    hour: .now,
                    imageURL: "",
                    address: "Circuit de Spa-Francorchamps",
                    location: .init(latitude: 0, longitude: 0),
                    creatorID: "unautresuperid"),
            session: UserSessionViewModel())
        let creator = await viewModel.getUser(with: "unautresuperid")
        XCTAssertEqual(creator.email, "unknow")
    }

    @MainActor
    func testGetUserShouldFailedWithError() async {
        let viewModel = EventViewModel(
            event: Event(
                    title: "Grand Prix Belgique",
                    descrition: "Grand Prix Belgique",
                    date: "27/27/2025".toDate() ?? .now,
                    hour: .now,
                    imageURL: "",
                    address: "Circuit de Spa-Francorchamps",
                    location: .init(latitude: 0, longitude: 0),
                    creatorID: "no"),
            session: UserSessionViewModel())
        let creator = await viewModel.getUser(with: "no")
        XCTAssertEqual(creator.email, "unknow")
    }
    
    @MainActor
    func testAddEventShouldSucceed() async {
        let session = UserSessionViewModel()
        session.currentUser = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
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
        
        await eventVM.addEvent()
        
        XCTAssertEqual(session.currentUser?.subscribedEvents.count, 1)
    }
    
    @MainActor
    func testRemoveEventShouldSucceed() async {
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
        
        await eventVM.removeEvent()
        
        XCTAssertEqual(session.currentUser?.subscribedEvents.count, 0)
    }
    
    @MainActor
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
    
    @MainActor
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
    
    @MainActor
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
