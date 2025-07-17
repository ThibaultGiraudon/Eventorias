//
//  AuthRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import FirebaseAuth

class AuthRepository {
    let auth = Auth.auth()
    
    func register(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password, completion: completion)
    }
    
    func authenticate(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            print("Error signing out \(error)")
            completion(error)
        }
    }
}
