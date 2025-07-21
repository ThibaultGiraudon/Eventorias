//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            Auth.auth().useEmulator(withHost: "localhost", port: 9000)
            Firestore.firestore().useEmulator(withHost: "localhost", port: 9010)
            Storage.storage().useEmulator(withHost: "localhost", port: 9020)
        }
        return true
    }
}

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var session = UserSessionViewModel()
    @StateObject var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView(session: session)
                .environmentObject(coordinator)
        }
    }
}
