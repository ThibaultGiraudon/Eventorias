//
//  NotificationHelper.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 24/07/2025.
//

import Foundation
import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var notificationsEnabled: Bool {
        print(UserDefaults.standard.bool(forKey: "notificationsEnabled"))
        return UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func createNotification(name: String, at date: Date) {
        guard notificationsEnabled else {
            print("User notification blocked")
            return
        }
        
        let timeUntilEvent = date.timeIntervalSinceNow

        if timeUntilEvent > 7200 {
            scheduleNotification(
                title: "It's almost time!",
                subtitle: "\(name) is starting in 2 hours.",
                timeInterval: timeUntilEvent - 7200
            )
        }
        if timeUntilEvent > 300 {
            scheduleNotification(
                title: "Get ready!",
                subtitle: "\(name) is starting in 5 minutes.",
                timeInterval: timeUntilEvent - 300
            )
        }
        scheduleNotification(title: "It's time!", subtitle: "\(name) is starting right now.", timeInterval: 5)
    }

    private func scheduleNotification(title: String, subtitle: String, timeInterval: TimeInterval) {
        guard timeInterval > 0 else { return } // Ne rien planifier si l'heure est passée

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        userNotificationCenter.add(request)
    }
}
