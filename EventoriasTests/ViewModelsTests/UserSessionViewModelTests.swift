//
//  UserSessionViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import XCTest
@testable import Eventorias
import FirebaseAuth

final class UserSessionViewModelTests: XCTestCase {
    
    func testUserShouldSucceed() {
        let user = User()
        
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.fullname, "")
        XCTAssertEqual(user.imageURL, user.defaultImage)
    }
    
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
    func testUploadImageShouldSucceed() async {
        guard let image = loadImage(named: "charles-leclerc.jpg") else {
            XCTFail("Failed to load image")
            return
        }
        
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        do {
            try await Auth.auth().createUser(withEmail: "testUserVM@test.app", password: "123456")
        } catch {
            XCTFail("Failed to create user")
        }
        
        await session.loadUser(by: "123")
        await session.uploadImage(image)
        XCTAssertNotEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        await session.uploadImage(image)
    }
    
    @MainActor
    func testUploadImageShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        let image = UIImage()
        
        await session.loadUser(by: "123")
        await session.uploadImage(image)
        XCTAssertEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        XCTAssertEqual(session.error, "Failed to upload image")
    }
    
    @MainActor
    func testUploadImageShouldFailedWithUserNotLogged() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let userRepositoryFake = UserRepositoryFake()
        let session = UserSessionViewModel(userRepository: userRepositoryFake, authRepository: authRepositoryFake)
        
        let image = UIImage()
        
        await session.uploadImage(image)
        XCTAssertEqual(session.currentUser?.imageURL, userRepositoryFake.user?.imageURL)
        XCTAssertEqual(session.error, "User not logged in")
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
    
    func loadImage(named name: String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
