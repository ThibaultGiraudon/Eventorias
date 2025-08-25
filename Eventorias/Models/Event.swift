//
//  Event.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

/// A model reprenting an event.
///
/// Include basic information, location, creatorID and participants list.
struct Event: Codable, Identifiable, Hashable {
    
    // MARK: - Prorpeties
    
    /// The unique identifier of the event.
    var id = UUID().uuidString
    
    /// The event's title.
    var title: String
    
    /// The event's description.
    var descrition: String
    
    /// The event's starting date.
    var date: Date
    
    /// The event's starting hour.
    var hour: Date
    
    /// The URL of the event's image.
    var imageURL: String
    
    /// The event's address.
    var address: String
    
    /// The event's location to display on Map.
    var location: Location
    
    /// The event's creator id.
    var creatorID: String
    
    /// A list of user ID subsribed to the event.
    var participants: [String] = []
    
    struct Location: Codable, Hashable {
        var latitude: Double
        var longitude: Double
    }
}
