//
//  Tab.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation

enum Tab: String, CaseIterable {
    case events, profile
    
    var icon: String {
        switch self {
        case .events:
            "calendar"
        case .profile:
            "person"
        }
    }
}
