//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var user: User = .init()
    
    let authRepository = AuthRepository()
    let userRepository = UserRepository()
    
    func authenticate(completion: @escaping () -> Void) {
        authRepository.authenticate(email: email, password: password) { _, error in
            if let err = error {
                print(err)
                return
            }
            self.isLoggedIn = true
            completion()
        }
    }
    
    func register(completion: @escaping () -> Void) {
        authRepository.register(email: email, password: password) { result, error in
            if let err = error {
                print(err)
                return
            }
            guard let uid = result?.user.uid else {
                return
            }
            self.user = User(uid: uid, email: self.email, fullname: self.fullname, imageURL: nil)
            self.userRepository.setUser(self.user) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
            self.isLoggedIn = true
            completion()
        }
    }
    
    func signOut() {
        authRepository.signOut { error in
            if let err = error {
                print(err)
                return
            }
            self.isLoggedIn = false
        }
    }
}
