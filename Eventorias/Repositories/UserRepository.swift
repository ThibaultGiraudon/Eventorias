//
//  UserRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import Firebase

class UserRepository {
    let db = Firestore.firestore()
    
    func getUser(withId uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        return User(document: document)
    }
    
    func setUser(_ user: User, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "email": user.email,
            "fullname": user.fullname,
            "imageURL": user.imageURL,
            "uid": user.uid
        ]
        
        db.collection("users").document(user.uid).setData(data, completion: completion)
    }
}
