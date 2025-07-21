//
//  StorageRepositoryTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import XCTest
@testable import Eventorias
import FirebaseStorage

final class StorageRepositoryTests: XCTestCase {

    var storageRepository: StorageRepository!
    
    override func setUp() {
        super.setUp()
        
        storageRepository = StorageRepository()
    }

    override func tearDown() {
        storageRepository = nil
        super.tearDown()
    }
    
    func testUploadAndDeleteImageShouldSucceed() async {
        guard let image = loadImage(named: "charles-leclerc.jpg") else {
            XCTFail("Failed to get UIImage")
            return
        }
        
        do {
            let url = try await storageRepository.uploadImage(image)
            XCTAssert(!url.isEmpty, "URL should not be empty")
            try await storageRepository.deleteImage(with: url)
        } catch {
            XCTFail("Upload or delete image failed with: \(error)")
        }
    }
    
    func testUploadImageShouldFailed() async {
        let image = UIImage()
        
        do {
            _ = try await storageRepository.uploadImage(image)
            XCTFail("Uploading image should fails.")
        } catch {
            XCTAssertEqual(error.localizedDescription, URLError(.badURL).localizedDescription)
        }
    }
    
    func loadImage(named name: String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
}
