//
//  ContentView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                HomeView()
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    HomeView()
                case .mail:
                    AuthenticateMailView()
                case .register:
                    RegisterView()
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var authViewModel = AuthViewModel()
    @Previewable @StateObject var coordinator = AppCoordinator()
    
    ContentView()
        .environmentObject(authViewModel)
        .environmentObject(coordinator)
}
