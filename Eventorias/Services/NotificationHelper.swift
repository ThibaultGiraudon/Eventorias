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
    
    /// Computed var to check if user enables notification.
    var notificationsEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    /// Initializes a new `NotificationHelper` object.
    /// Request notification authorization.
    init() {
        requestAuthorization()
    }
    
    /// Asks user authorization to send notification
    private func requestAuthorization() {
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Creates a new notification with specified name.
    /// Send notification 2 hours and 5 minutes before event's start.
    ///
    /// - Parameters:
    ///   - name: The subtitle `String` of the new notification.
    ///   - date: The starting `Date` of the event.
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
    }

    /// Creates the notification.
    ///
    /// - Parameters:
    ///   - title: The title `String` of the notification.
    ///   - subtitle: The subtitle `String` of the notification.
    ///   - timeInterval: The time in second before sendig the notification.
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
