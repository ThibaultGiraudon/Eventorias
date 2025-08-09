//
//  StorageRepositoryFake.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias

class StorageRepositoryFake: StorageRepositoryInterface {
    var imageURL: String = ""
    var error: Error?
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String {
        if let error {
            throw error
        }
        return imageURL
    }
    
    func deleteImage(with url: String) async throws {
        if let error {
            throw error
        }
    }
    
    
}
