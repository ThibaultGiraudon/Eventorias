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
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        let env = ProcessInfo.processInfo.environment
        let isUnitTest = env["XCTestConfigurationFilePath"] != nil
        let isUITest = env["-useFirebaseEmulator"] == "YES" || ProcessInfo.processInfo.arguments.contains("-useFirebaseEmulator")

        if isUnitTest || isUITest {
            Auth.auth().useEmulator(withHost: "localhost", port: 9000)
            Firestore.firestore().useEmulator(withHost: "localhost", port: 9010)
            Storage.storage().useEmulator(withHost: "localhost", port: 9020)
        }
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return false
        }
        GMSServices.provideAPIKey(apiKey)
        
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
