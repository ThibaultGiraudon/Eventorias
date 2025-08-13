//
//  EventoriasUITests.swift
//  EventoriasUITests
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import XCTest

final class EventoriasUITests: XCTestCase {
    
    let testEmail = "tibo@test.com"
    let testFullname = "Tibo Giraudon"
    let testPassword = "qwerty132!"
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        resetFirebaseEmulators()
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments += ["-useFirebaseEmulator", "YES"]
        app.launch()
    }
    
    func test_fullFlow_createAccount_logout_login_addEvent_checkEventList() throws {
        createAccount(email: testEmail, fullname: testFullname, password: testPassword)
        XCTAssertTrue(app.staticTexts["emptyEventsMessage"].waitForExistence(timeout: 10))
        
        logout()
        XCTAssertTrue(app.buttons["Sign in with email"].waitForExistence(timeout: 5))

        login(email: testEmail, password: testPassword)

        addEvent()
        XCTAssertTrue(app.staticTexts["Grand Prix Monaco"].waitForExistence(timeout: 10))
        
        goToEvent()
    }
    
    // MARK: - Helpers
    
    func goToEvent() {
        app.staticTexts["Grand Prix Monaco"].tap()
        XCTAssertTrue(app.staticTexts["Monaco"].waitForExistence(timeout: 5))
    }
    
    func createAccount(email: String, fullname: String, password: String) {
        app.buttons["Sign in with email"].tap()
        let createAccountButton = app.buttons["createAccountButton"]
        XCTAssertTrue(createAccountButton.waitForExistence(timeout: 5))
        XCTAssertTrue(createAccountButton.isHittable)
        createAccountButton.tap()
        
        let emailField = app.textFields["Email"]
        let fullnameField = app.textFields["Fullname"]
        let passwordField = app.secureTextFields["Password"]
        
        emailField.tap()
        emailField.typeText(email)
        
        fullnameField.tap()
        fullnameField.typeText(fullname)
        
        passwordField.tap()
        passwordField.typeText(password)
                
        app.buttons["Create an account"].tap()
    }
    
    func logout() {
        let profileButton = app.staticTexts["profile"]
        profileButton.tap()
        app.buttons["Log Out"].tap()
    }
    
    func login(email: String, password: String) {
        app.buttons["Sign in with email"].tap()
        
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        
        emailField.tap()
        emailField.typeText(email)
        
        passwordField.tap()
        passwordField.typeText(password)
        
        app.buttons["Sign in"].tap()
    }
    
    func addEvent() {
        let listButton = app.staticTexts["list"]
        listButton.tap()
        
        app.buttons["Add"].tap()
        
        let eventNameField = app.textFields["New event"]
        let eventDescriptionField = app.textFields["Tap here to enter your description"]
        let eventDateField = app.textFields["MM/DD/YYYY"]
        let eventTimeField = app.textFields["HH:MM"]
        let eventAddressField = app.textFields["Enter full address"]
        
        eventNameField.tap()
        eventNameField.typeText("Grand Prix Monaco\n")
        
        eventDescriptionField.tap()
        eventDescriptionField.typeText("Grand Prix Monaco\n")
        
        eventDateField.tap()
        eventDateField.typeText("07/08/2025\n")
        
        eventTimeField.tap()
        eventTimeField.typeText("15:00\n")

        let galleryButton = app.images["Attachements"]
        if !galleryButton.isHittable {
            let scrollView = app.scrollViews["addScrollView"]
            scrollView.swipeUp()
        }
        galleryButton.tap()
        
        sleep(3)
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        
        eventAddressField.tap()
        eventAddressField.typeText("Monaco\n")
        
        let addButton = app.buttons["Validate"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
    }
    
    private func resetFirebaseEmulators() {
        let projectId = "eventorias-df464"
        let bucketName = "\(projectId).appspot.com"
        
        let endpoints = [
            "http://localhost:9000/emulator/v1/projects/\(projectId)/accounts",
            "http://localhost:9010/emulator/v1/projects/\(projectId)/databases/(default)/documents",
            "http://localhost:9020/emulator/v1/projects/\(projectId)/buckets/\(bucketName)/o"
        ]
        
        let session = URLSession(configuration: .ephemeral)
        let group = DispatchGroup()
        
        for endpoint in endpoints {
            guard let url = URL(string: endpoint) else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            group.enter()
            session.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("⚠️ Error resetting \(endpoint): \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("✅ \(endpoint) reset (status: \(httpResponse.statusCode))")
                }
                group.leave()
            }.resume()
        }
        
        group.wait()
    }
}
