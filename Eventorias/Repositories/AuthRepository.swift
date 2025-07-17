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
    
    func identifyError(_ error: Error) -> String {
        if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
                switch errCode {
                case .networkError:
                    return "Problème de connexion internet."
                case .userNotFound:
                    return "Aucun compte ne correspond à cet email."
                case .wrongPassword, .invalidCredential:
                    return "Mot de passe incorrect."
                case .emailAlreadyInUse:
                    return "Cet email est déjà utilisé."
                case .invalidEmail:
                    return "Format d'email invalide."
                case .weakPassword:
                    return "Mot de passe trop faible (6 caractères min.)."
                case .tooManyRequests:
                    return "Trop de tentatives. Réessayez plus tard."
                default:
                    return "Une erreur est survenue : \(errCode.rawValue)"
                }
            }

            return "Erreur inconnue : \(error.localizedDescription)"
    }
}
