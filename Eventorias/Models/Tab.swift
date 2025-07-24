//
//  Tab.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

enum TabItem: String, CaseIterable {
    case profile, list, calendar
    
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
