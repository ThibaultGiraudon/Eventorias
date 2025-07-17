//
//  AppCoordinator.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import Foundation

class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    
    func goToMail() {
        path.append(.mail)
    }
    
    func goToRegister() {
        path.append(.register)
    }
    
    func resetNavigation() {
        path = []
    }
}

enum AppRoute: Hashable {
    case home
    case mail
    case register
}
