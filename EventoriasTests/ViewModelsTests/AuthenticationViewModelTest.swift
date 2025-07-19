//
//  AuthenticationViewModelTest.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 18/07/2025.
//

import XCTest
import FirebaseAuth
@testable import Eventorias

final class AuthenticationViewModelTest: XCTestCase {
    @MainActor
    func testSignInShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.signIn()
        } catch {
            XCTFail("SignIn should not throws error")
        }

        XCTAssertEqual(viewModel.authenticationState, .signedIn)
    }

    @MainActor
    func testSignInShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = URLError(.badURL)
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.signIn()
        } catch {
            XCTAssertEqual(error.localizedDescription, URLError(.badURL).localizedDescription)
        }

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    @MainActor
    func testRegisterShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.register()
        } catch {
            XCTFail("Register should not throws error")
        }

        XCTAssertEqual(viewModel.authenticationState, .signedIn)
    }
    
    @MainActor
    func testRegisterShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = URLError(.badURL)
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.register()
        } catch {
            XCTAssertEqual(error.localizedDescription, URLError(.badURL).localizedDescription)
        }

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    @MainActor
    func testSignOutShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signOut()

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    @MainActor
    func testSignOutShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = URLError(.badURL)
        let session = UserSessionViewModel(authRepository: authRepositoryFake)
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = User(uid: "123", email: "charles.leclerc@ferrari.mc", fullname: "Charles Leclerc", imageURL: nil)
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signOut()

        XCTAssertEqual(viewModel.error, URLError(.badURL).localizedDescription)
    }
}
