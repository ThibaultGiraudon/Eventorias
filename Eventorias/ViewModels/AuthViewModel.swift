//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var error: String?

    private let authService: AuthRepository
    private let userRepository: UserRepository
    private unowned let session: UserSessionViewModel

    init(session: UserSessionViewModel,
         authService: AuthRepository = AuthRepository(),
         userRepository: UserRepository = UserRepository()) {
        self.authService = authService
        self.userRepository = userRepository
        self.session = session
    }

    func signIn(completion: @escaping () -> Void) {
        authService.authenticate(email: email, password: password) { result, error in
            if let error = error {
                print("Sign in error: \(error)")
                self.error = self.authService.identifyError(error)
                return
            }

            guard let uid = result?.user.uid else { return }

            Task {
                await self.session.loadUser(by: uid)
                completion()
            }
        }
    }

    func register(completion: @escaping () -> Void) {
        authService.register(email: email, password: password) { result, error in
            if let error = error {
                print("Register error: \(error)")
                self.error = self.authService.identifyError(error)
                return
            }

            guard let uid = result?.user.uid else { return }

            let newUser = User(uid: uid, email: self.email, fullname: self.fullname, imageURL: nil)

            self.userRepository.setUser(newUser) { error in
                if let error = error {
                    print("Saving user failed: \(error)")
                    return
                }

                Task {
                    await self.session.loadUser(by: uid)
                    completion()
                }
            }
        }
    }

    func signOut() {
        authService.signOut { error in
            if let error = error {
                print("Sign out error: \(error)")
                self.error = error.localizedDescription
                return
            }
            self.session.logout()
        }
    }
}
