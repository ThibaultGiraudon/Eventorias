//
//  EventViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 22/07/2025.
//

import XCTest
@testable import Eventorias

final class EventViewModelTests: XCTestCase {
    
    func testGetUserShouldSucceed() async {
        let userRepository = UserRepository()
        let user = User(uid: UUID().uuidString, email: "isack.hadjar@vcarb.fr", fullname: "Isack Hadjar", imageURL: nil)
        userRepository.setUser(user)
        let viewModel = EventViewModel(event: Event(
            title: "Grand Prix Belgique",
            descrition: "Grand Prix Belgique",
            date: "27/27/2025".toDate() ?? .now,
            hour: .now,
            imageURL: "",
            address: "Circuit de Spa-Francorchamps",
            location: .init(latitude: 0, longitude: 0),
            creatorID: user.uid))
        let creator = await viewModel.getUser(with: user.uid)
        XCTAssertEqual(creator.email, "isack.hadjar@vcarb.fr")
    }
    
    func testGetUserShouldFailed() async {
        let userRepository = UserRepository()
        userRepository.setData([:], id: "unautresuperid")
        let viewModel = EventViewModel(event: Event(
            title: "Grand Prix Belgique",
            descrition: "Grand Prix Belgique",
            date: "27/27/2025".toDate() ?? .now,
            hour: .now,
            imageURL: "",
            address: "Circuit de Spa-Francorchamps",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "unautresuperid"))
        let creator = await viewModel.getUser(with: "unautresuperid")
        XCTAssertEqual(creator.email, "unknow")
    }

    func testGetUserShouldFailedWithError() async {
        let viewModel = EventViewModel(event: Event(
            title: "Grand Prix Belgique",
            descrition: "Grand Prix Belgique",
            date: "27/27/2025".toDate() ?? .now,
            hour: .now,
            imageURL: "",
            address: "Circuit de Spa-Francorchamps",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "no"))
        let creator = await viewModel.getUser(with: "no")
        XCTAssertEqual(creator.email, "unknow")
    }
}
