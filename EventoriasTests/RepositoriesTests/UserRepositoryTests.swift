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
        
        userRepository = UserRepository()
    }
    
    override func tearDown() {
        userRepository = nil
        super.tearDown()
    }
    
    func testGetUserShouldFailedWithUserNilNoEmail() async {
        
        do {
            userRepository.setData(["test": "test"], id: "test")
            let fetchedUser = try await userRepository.getUser(withId: "test")
            XCTAssertNil(fetchedUser)
        } catch {
            XCTFail("Geting user should not throw error: \(error)")
        }
    }
    
    func testGetUserShouldFailedWithUserNilNoFullName() async {
        
        do {
            userRepository.setData(["email": "test@test.fr"], id: "test")
            let fetchedUser = try await userRepository.getUser(withId: "test")
            XCTAssertNil(fetchedUser)
        } catch {
            XCTFail("Geting user should not throw error: \(error)")
        }
    }
    
    func testGetUserShouldFailedWithUserNilNoImageURL() async {
        do {
            userRepository.setData(["email": "test@test.fr", "fullname": "fulltest"], id: "test")
            let fetchedUser = try await userRepository.getUser(withId: "test")
            XCTAssertEqual(fetchedUser?.email, "test@test.fr")
        } catch {
            XCTFail("Geting user should not throw error: \(error)")
        }
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
