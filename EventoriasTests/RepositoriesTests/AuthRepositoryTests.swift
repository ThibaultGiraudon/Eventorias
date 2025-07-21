//
//  AuthRepositoryTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 19/07/2025.
//

import XCTest
@testable import Eventorias
import FirebaseAuth
import Firebase

final class AuthRepositoryTests: XCTestCase {

    var authRepository: AuthRepository!
    
    override func setUp() {
        super.setUp()
        
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9000)
        
        authRepository = AuthRepository(auth: auth)
    }
    
    override func tearDown() {
        authRepository = nil
        super.tearDown()
    }

    func testRegisterAndAuthenticationAndSignOutShouldSucceed() async {
        let email = "testuser@example.com"
        let password = "testpassword"
        
        do {
            let uid = try await authRepository.register(email: email, password: password)
            XCTAssertFalse(uid.isEmpty, "UID should not be empty after registration")
        } catch {
            XCTFail("Registration failed with \(error)")
        }
        
        do {
            try authRepository.signOut()
            XCTAssertNil(authRepository.auth.currentUser)
        } catch {
            XCTFail("Signing out failed with \(error)")
        }
        
        do {
            let uid = try await authRepository.authenticate(email: email, password: password)
            XCTAssertFalse(uid.isEmpty, "UID should not be empty after authentication")
        } catch {
            XCTFail("Authentication failed with \(error)")
        }
    }
    
    func testRegisterShouldFailWithBadEmailFormat() async {
        let email = "testuser"
        let password = "testpassword"
        
        do {
            _ = try await authRepository.register(email: email, password: password)
            XCTFail("Registration should failed")
        } catch {
            let nsError = error as NSError
            let authCode = AuthErrorCode(rawValue: nsError.code)
            XCTAssertEqual(authCode, AuthErrorCode.invalidEmail)
        }
    }

    func testAuthenticationShouldFailWithUserNotFound() async {
        let email = "test2@example.com"
        let password = "testpassword"
        
        do {
            _ = try await authRepository.authenticate(email: email, password: password)
            XCTFail("Registration should failed")
        } catch {
            let nsError = error as NSError
            let authCode = AuthErrorCode(rawValue: nsError.code)
            XCTAssertEqual(authCode, AuthErrorCode.userNotFound)
        }
    }
    
    func testIdentifyError() {
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.networkError), "Internet connection problem.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.userNotFound), "No account matches this email.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.wrongPassword), "Incorrect password.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.invalidCredential), "Incorrect password.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.emailAlreadyInUse), "This email is already in use.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.invalidEmail), "Invalid email format.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.weakPassword), "Password is too weak (minimum 6 characters).")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.tooManyRequests), "Too many attempts. Please try again later.")
        XCTAssertEqual(authRepository.identifyError(AuthErrorCode.internalError), "An error occurred: \(AuthErrorCode.internalError.rawValue)")
        XCTAssertEqual(authRepository.identifyError(URLError(.badURL)), "Unknown error: \(URLError(.badURL).localizedDescription)")
    }
    
    /// **note** Test should not succeed user email should be newuser@example.com
    func testEditUserShouldSucceed() async {
        let email = "testuser2@example.com"
        let password = "testpassword"
        
        do {
            let uid = try await authRepository.register(email: email, password: password)
            XCTAssertFalse(uid.isEmpty, "UID should not be empty after registration")
            KeychainHelper.shared.save(email, for: "UserEmail")
            KeychainHelper.shared.save(password, for: "UserPassword")
            try await authRepository.editUser(email: "newuser@example.com")
            XCTAssertEqual(authRepository.auth.currentUser?.email, email)
        } catch {
            XCTFail("Registration failed with \(error)")
        }
    }
    
    func testEditUserShouldFailedwithMissingCredentials() async {
        let email = "testuser3@example.com"
        let password = "testpassword"
        
        do {
            let uid = try await authRepository.register(email: email, password: password)
            XCTAssertFalse(uid.isEmpty, "UID should not be empty after registration")
            KeychainHelper.shared.delete(for: "UserEmail")
            KeychainHelper.shared.delete(for: "UserPassword")
            try await authRepository.editUser(email: "newuser@example.com")
            XCTFail("Edition should failed")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Missing credentials")
        }
    }
}
