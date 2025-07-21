//
//  UserSessionViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import XCTest
@testable import Eventorias

final class UserSessionViewModelTests: XCTestCase {
    @MainActor
    func testLoadUserShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        guard let user = session.currentUser else {
            XCTFail("Current User should not be nil")
            return
        }
        
        XCTAssertEqual(user.fullname, "Charles Leclerc")
        XCTAssertTrue(session.isLoggedIn)
    }

    @MainActor
    func testLoadUserShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.error = URLError(.badURL)
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertEqual(session.error, URLError(.badURL).localizedDescription)
    }
    
    @MainActor
    func testLoadUserShouldFailedWithUserNotFound() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
        XCTAssertEqual(session.error, "User not found")
    }
    
    @MainActor
    func testUpdateUserShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        guard let user = session.currentUser else {
            XCTFail("Current user should not be nil")
            return
        }
        XCTAssertEqual(user.fullname, "Pierre Gasly")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithNotLoggedIn() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, "User not logged in")
    }
    
    @MainActor
    func testUpdateUserShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = URLError(.badURL)
        let userRepositoryFake = UserRepositoryFake()
        
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        session.currentUser = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        
        await session.updateUser(email: "pierre.gasly@alpine.fr", fullname: "Pierre Gasly")
        
        XCTAssertEqual(session.error, URLError(.badURL).localizedDescription)
    }
    
    @MainActor
    func testLogout() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        await session.loadUser(by: "123")
        
        guard let user = session.currentUser else {
            XCTFail("Current User should not be nil")
            return
        }
        
        XCTAssertEqual(user.fullname, "Charles Leclerc")
        XCTAssertTrue(session.isLoggedIn)
        
        session.logout()
        
        XCTAssertNil(session.currentUser)
        XCTAssertFalse(session.isLoggedIn)
    }
}
