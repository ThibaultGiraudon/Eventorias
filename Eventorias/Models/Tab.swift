//
//  Tab.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

/// The different main view to display after the user logged in.
enum TabItem: String, CaseIterable {
    case list, calendar, profile
    
    var icon: String {
        switch self {
        case .list:
            "list.bullet"
        case .calendar:
            "calendar"
        case .profile:
            "person"
        }
    }
}
