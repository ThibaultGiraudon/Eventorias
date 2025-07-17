//
//  UserViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

@MainActor
class UserSessionViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let userRepository: UserRepository

    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
    }

    func loadUser(by uid: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            guard let user = try await userRepository.getUser(withId: uid) else {
                error = "User not found"
                return
            }
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            self.error = error.localizedDescription
        }
    }

    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
    }
}
