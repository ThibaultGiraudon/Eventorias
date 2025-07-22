//
//  ContentView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @MainActor @ObservedObject var session: UserSessionViewModel
    @MainActor @StateObject var authVM: AuthenticationViewModel
    @StateObject var addEventVM: AddEventViewModel
    @StateObject var eventsVM: EventsViewModel
    
    init(session: UserSessionViewModel) {
        self.session = session
        self._authVM = StateObject(wrappedValue: AuthenticationViewModel(session: session))
        self._addEventVM = StateObject(wrappedValue: AddEventViewModel(session: session))
        self._eventsVM = StateObject(wrappedValue: EventsViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack { 
                HomeView(session: session, authVM: authVM, eventsVM: eventsVM)
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    HomeView(session: session, authVM: authVM, eventsVM: eventsVM)
                case .mail:
                    AuthenticateMailView(authVM: authVM)
                case .register:
                    RegisterView(authVM: authVM)
                case .addEvent:
                    AddEventView(viewModel: addEventVM)
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var coordinator = AppCoordinator()
    @Previewable @StateObject var session = UserSessionViewModel()
    ContentView(session: session)
        .environmentObject(coordinator)
}
