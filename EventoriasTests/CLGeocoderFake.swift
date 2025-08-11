//
//  CLGeocoderFake.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 23/07/2025.
//

import Foundation
@testable import Eventorias
import CoreLocation

class CLGeocoderFake: CLGeocoderInterface {
    var placemarks: [CLPlacemark] = []
    var error: Error?
    
    func geocodeAddressString(_ address: String) async throws -> [CLPlacemark] {
        if let error = error {
            throw error
        }
        return placemarks
    }
}
