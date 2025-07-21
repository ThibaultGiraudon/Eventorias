//
//  UserRepositoryTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 19/07/2025.
//

import XCTest
@testable import Eventorias
import Firebase

final class UserRepositoryTests: XCTestCase {

    var userRepository: UserRepository!
    
    override func setUp() {
        super.setUp()
        
//        let db = Firestore.firestore()
//        db.useEmulator(withHost: "localhost", port: 9010)
        
        userRepository = UserRepository()
    }
    
    override func tearDown() {
        userRepository = nil
        super.tearDown()
    }

    func testSetUserAndGetUserShouldSucceed() async {
        let user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        
        userRepository.setUser(user)
        
        do {
            let fetchedUser = try await userRepository.getUser(withId: "123")
            XCTAssertEqual(fetchedUser, user)
        } catch {
            XCTFail("Geting user failed with \(error)")
        }
    }
    
    func testGetUserShouldFailedWithUnavailable() async {
        do {
            _ = try await userRepository.getUser(withId: "1")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, FirestoreErrorDomain)
            XCTAssertEqual(nsError.code, FirestoreErrorCode.unavailable.rawValue)
        }
    }
    
}
