//
//  AuthenticationViewModelTests.swift
//  EventoriasTests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest
@testable import Eventorias

@MainActor
final class AuthenticationViewModelTest: XCTestCase {
    
    func testSignInShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signIn()

        XCTAssertEqual(viewModel.authenticationState, .signedIn)
    }

    func testSignInShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = FakeData().error
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signIn()

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    func testRegisterShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.register()
        } catch {
            XCTFail("Register should not throws error")
        }

        XCTAssertEqual(viewModel.authenticationState, .signedIn)
    }
    
    func testRegisterShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = FakeData().error
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        do {
            try await viewModel.register()
        } catch {
            XCTAssertEqual(error.localizedDescription, FakeData().error.localizedDescription)
        }

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    func testSignOutShouldSucceed() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signOut()

        XCTAssertEqual(viewModel.authenticationState, .signedOut)
    }
    
    func testSignOutShouldFailedWithError() async {
        let authRepositoryFake = AuthenticationRepositoryFake()
        authRepositoryFake.error = FakeData().error
        let session = UserSessionViewModel(authRepository: authRepositoryFake, eventsRepository: EventsRepositoryFake())
        let userRepositoryFake = UserRepositoryFake()
        userRepositoryFake.user = FakeData().user
        let viewModel = AuthenticationViewModel(session: session, authRepository: authRepositoryFake, userRepository: userRepositoryFake)
        
        await viewModel.signOut()

        XCTAssertEqual(viewModel.error, FakeData().error.localizedDescription)
    }
}
