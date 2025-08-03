//
//  AuthRepositoryInterface.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import Foundation
import FirebaseAuth

/// A protocol that defines authentication-related operation.
protocol AuthRepositoryInterface {
    func register(email: String, password: String) async throws -> String
    func authenticate(email: String, password: String) async throws -> String
    func signOut() throws
    func editUser(email: String) async throws
    func identifyError(_ error: Error) -> String 
}
