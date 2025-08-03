//
//  UserRepositoryInterface.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import Foundation

/// A protocol that defines user-related operation.
protocol UserRepositoryInterface {
    func getUser(withId uid: String) async throws -> User?
    func setUser(_ user: User)
}
