//
//  User.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import FirebaseFirestore

struct User {
    let uid: String
    var email: String
    var fullname: String
    var imageURL: String
        
    init(uid: String, email: String, fullname: String, imageURL: String?) {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        if let imageURL = imageURL {
            self.imageURL = imageURL
        } else {
            self.imageURL = "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/profils_image%2Fdefault-profile-image.jpg?alt=media&token=c9a78295-2ad4-4acf-872d-c193116783c5"
        }
    }
    
    init() {
        self.uid = UUID().uuidString
        self.email = ""
        self.fullname = ""
        self.imageURL = "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/profils_image%2Fdefault-profile-image.jpg?alt=media&token=c9a78295-2ad4-4acf-872d-c193116783c5"
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let email = data["email"] as? String,
              let fullname = data["fullname"] as? String else {
            return nil
        }

        self.uid = document.documentID
        self.email = email
        self.fullname = fullname
        self.imageURL = data["imageURL"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/profils_image%2Fdefault-profile-image.jpg?alt=media&token=c9a78295-2ad4-4acf-872d-c193116783c5"
    }
}
