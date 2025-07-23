//
//  Event.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

struct Event: Codable, Identifiable, Hashable {    
    var id = UUID().uuidString
    var title: String
    var descrition: String
    var date: Date
    var hour: Date
    var imageURL: String
    var address: String
    var location: Location
    var creatorID: String
    var participants: [String] = []
    
    struct Location: Codable, Hashable {
        var latitude: Double
        var longitude: Double
    }
}
