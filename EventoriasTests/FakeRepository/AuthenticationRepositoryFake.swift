//
//  AuthenticationRepositoryFake.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import Foundation
import FirebaseAuth
@testable import Eventorias

class AuthenticationRepositoryFake: AuthRepositoryInterface {
    var error: Error?
    var uid: String = "123"
    var errorDescription: String = ""
    func register(email: String, password: String) async throws -> String {
        if let error = error {
            throw error
        }
        return uid
    }
    
    func authenticate(email: String, password: String) async throws -> String {
        if let error = error {
            throw error
        }
        return uid
    }
    
    func signOut() throws {
        if let error = error {
            throw error
        }
    }
    
    func editUser(email: String) throws {
        if let error = error {
            throw error
        }
    }
    
    func identifyError(_ error: any Error) -> String {
        return errorDescription
    }
    
}
