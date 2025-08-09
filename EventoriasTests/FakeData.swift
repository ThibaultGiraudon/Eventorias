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
            descrition: "Grand Prix Monaco",
            date: String("07/08/2003").toDate() ?? .now,
            hour: String("07/08/2003").toDate() ?? .now,
            imageURL: "",
            address: "Monaco",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "123",
            participants: ["123"]
        ),
        Event(
            id: "2",
            title: "Grand Prix Imola",
            descrition: "Grand Prix Imola",
            date: String("08/08/2003").toDate() ?? .distantPast,
            hour: String("07/08/2003").toDate() ?? .now,
            imageURL: "",
            address: "Imola",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "123",
            participants: ["123"]
        ),
        Event(
            id: "3",
            title: "Grand Prix Monza",
            descrition: "Grand Prix Monza",
            date: String("08/08/2003").toDate() ?? .distantPast,
            hour: String("07/08/2003").toDate() ?? .now,
            imageURL: "",
            address: "Monza",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "234",
            participants: ["123"]),
        Event(
            id: "4",
            title: "Grand Prix Singapour",
            descrition: "Grand Prix Singapour",
            date: String("07/08/2003").toDate() ?? .now,
            hour: String("07/08/2003").toDate() ?? .now,
            imageURL: "",
            address: "Singapour",
            location: .init(latitude: 0, longitude: 0),
            creatorID: "234",
            participants: ["123"])
    ]
    let monaco = Event(
        id: "1",
        title: "Grand Prix Monaco",
        descrition: "Grand Prix Monaco",
        date: String("07/08/2003").toDate() ?? .now,
        hour: String("07/08/2003").toDate() ?? .now,
        imageURL: "",
        address: "Monaco",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "123",
        participants: ["123"]
    )
    let imola = Event(
        id: "2",
        title: "Grand Prix Imola",
        descrition: "Grand Prix Imola",
        date: String("08/08/2003").toDate() ?? .distantPast,
        hour: String("07/08/2003").toDate() ?? .now,
        imageURL: "",
        address: "Imola",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "123",
        participants: ["123"]
    )
    let monza = Event(
        id: "3",
        title: "Grand Prix Monza",
        descrition: "Grand Prix Monza",
        date: String("08/08/2003").toDate() ?? .distantPast,
        hour: String("07/08/2003").toDate() ?? .now,
        imageURL: "",
        address: "Monza",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "234",
        participants: ["123"])
    let singapour = Event(
        id: "4",
        title: "Grand Prix Singapour",
        descrition: "Grand Prix Singapour",
        date: String("07/08/2003").toDate() ?? .now,
        hour: String("07/08/2003").toDate() ?? .now,
        imageURL: "",
        address: "Singapour",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "234",
        participants: ["123"])
    let createdEvent = Event(
        id: "1",
        title: "Grand Prix Monaco",
        descrition: "",
        date: String("07/08/2003").toDate() ?? .now,
        hour: String("07/08/2003").toDate() ?? .now,
        imageURL: "",
        address: "",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "123",
        participants: ["123"])
    let subscribedEvent = Event(
        id: "2",
        title: "Grand Prix Monza",
        descrition: "",
        date: String("07/08/2003").toDate() ?? .now,
        hour: .now,
        imageURL: "",
        address: "",
        location: .init(latitude: 0, longitude: 0),
        creatorID: "234",
        participants: ["123"])
    let error = URLError(.badURL)
    let imageURL = "https://test.fr"
}
