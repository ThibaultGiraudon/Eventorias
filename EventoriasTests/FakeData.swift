//
//  FakeData.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import Foundation
@testable import Eventorias

struct FakeData {
    let user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
    let events = [
        Event(
            id: "1",
            title: "Grand Prix Monaco",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "123",
            participants: ["123"]
        ),
        Event(
            id: "2",
            title: "Grand Prix Imola",
            descrition: "",
            date: .distantPast,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "123",
            participants: ["123"]
        ),
        Event(
            id: "3",
            title: "Grand Prix Monza",
            descrition: "",
            date: .now,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "234",
            participants: ["123"]),
        Event(
            id: "4",
            title: "Grand Prix Singapour",
            descrition: "",
            date: .distantPast,
            hour: .now,
            imageURL: "",
            address: "",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "234",
            participants: ["123"])
    ]
    let createdEvent = Event(
        id: "1",
        title: "Grand Prix Monaco",
        descrition: "",
        date: .now,
        hour: .now,
        imageURL: "",
        address: "",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "123",
        participants: ["123"])
    let subscribedEvent = Event(
        id: "2",
        title: "Grand Prix Monza",
        descrition: "",
        date: .now,
        hour: .now,
        imageURL: "",
        address: "",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "234",
        participants: ["123"])
    let error = URLError(.badURL)
    let imageURL = "https://test.fr"
}
