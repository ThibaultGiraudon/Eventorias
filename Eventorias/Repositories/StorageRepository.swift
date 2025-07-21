//
//  StorageRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import FirebaseStorage
import SwiftUI

class StorageRepository {
    let storage: Storage
    let ref: StorageReference
    
    init() {
        storage = Storage.storage()
        ref = storage.reference()
    }
    
    func uploadImage(_ uiImage: UIImage) async throws -> String {
        let newID = UUID().uuidString
        let imageRef = ref.child("profils_image/\(newID).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        guard let data = uiImage.pngData() else {
            throw URLError(.badURL)
        }
        
        _ = try await imageRef.putDataAsync(data, metadata: metaData)
        let downloadURL = try await imageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    func deleteImage(with url: String) async throws {
        try await storage.reference(forURL: url).delete()
    }
}
