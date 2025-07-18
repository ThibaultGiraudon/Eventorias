//
//  UserRepositoryFake.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import Foundation
@testable import Eventorias

class UserRepositoryFake: UserRepositoryInterface {
    var error: Error?
    var user: User?
    
    func getUser(withId uid: String) async throws -> Eventorias.User? {
        if let error = error {
            throw error
        }
        return user
    }

    func setUser(_ user: Eventorias.User) {
        
    }
    
}
