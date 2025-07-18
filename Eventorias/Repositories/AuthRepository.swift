//
//  AuthRepository.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation
import FirebaseAuth

/// A repository class that handles all authentication-related operations using Firebase Auth.
class AuthRepository {
    let auth = Auth.auth()
    
    /// Registers a new user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address to register.
    ///   - password: The user's chosen password.
    ///   - completion: A closure called with the result of the registration or an error.
    func register(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password, completion: completion)
        auth.currentUser?.sendEmailVerification()
    }
    
    /// Authenticates an existing user using email and password credentials.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure called with the result of the sign-in attempt or an error.
    func authenticate(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password, completion: completion)
    }
    
    /// Signs out the currently authenticated user.
    ///
    /// - Parameter completion: A closure called with an optional error if the sign-out fails.
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            print("Error signing out \(error)")
            completion(error)
        }
    }
    
    /// Attempts to update the current user's email after reauthentication.
    ///
    /// ⚠️ **Note:** This method currently does not work as intended. It returns no error,
    /// but the email is not updated. 
    ///
    /// - Parameters:
    ///   - email: The new email address to update.
    ///   - completion: A closure called with an optional error.
    func editUser(email: String, completion: @escaping (Error?) -> Void) {
        self.reauthenticateIfNeeded { error in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let user = self.auth.currentUser else {
                completion(AuthErrorCode.userNotFound)
                return
            }
            
            user.sendEmailVerification(beforeUpdatingEmail: email, completion: completion)
        }
    }
    
    /// Reauthenticates the current user using stored credentials from Keychain.
    ///
    /// - Parameter completion: A closure called with an optional error.
    func reauthenticateIfNeeded(completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser,
              let email = KeychainHelper.shared.read(for: "UserEmail"),
              let password = KeychainHelper.shared.read(for: "UserPassword") else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Missing credentials"]))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { _, error in
            completion(error)
        }
    }
    
    /// Translates Firebase Auth errors into user-friendly messages.
    ///
    /// - Parameter error: The error to identify.
    /// - Returns: A string description of the error suitable for display to users.
    func identifyError(_ error: Error) -> String {
        if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
            switch errCode {
            case .networkError:
                return "Internet connection problem."
            case .userNotFound:
                return "No account matches this email."
            case .wrongPassword, .invalidCredential:
                return "Incorrect password."
            case .emailAlreadyInUse:
                return "This email is already in use."
            case .invalidEmail:
                return "Invalid email format."
            case .weakPassword:
                return "Password is too weak (minimum 6 characters)."
            case .tooManyRequests:
                return "Too many attempts. Please try again later."
            default:
                return "An error occurred: \(errCode.rawValue)"
            }
        }
        return "Unknown error: \(error.localizedDescription)"
    }
}
