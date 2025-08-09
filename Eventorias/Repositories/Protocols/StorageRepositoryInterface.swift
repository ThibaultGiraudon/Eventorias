//
//  StorageRepositoryInterface.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import Foundation
import SwiftUI

protocol StorageRepositoryInterface {
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String
    func deleteImage(with url: String) async throws
}
