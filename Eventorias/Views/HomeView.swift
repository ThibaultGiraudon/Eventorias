//
//  HomeView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var session: UserSessionViewModel
    @ObservedObject var authVM: AuthenticationViewModel
    @ObservedObject var eventsVM: EventsViewModel
    @State private var selectedTab: TabItem = .list
    @State private var activeError: String?
    var body: some View {
        VStack {
            switch authVM.authenticationState {
            case .signedOut:
                AuthenticateView()
            case .signingIn:
                ProgressView()
            case .signedIn:
                VStack {
                    if let error = activeError {
                        ErrorView(error: error) {
                            Task {
                                await eventsVM.fetchEvents()
                                activeError = nil
                            }
                        }
                    } else {
                        switch selectedTab {
                        case .list:
                            EventsListView(eventsVM: eventsVM)
                        case .calendar:
                            EventsCalendarView(eventsVM: eventsVM)
                        case .profile:
                            ProfileView(session: session, authVM: authVM)
                        }
                    }
                    HStack(spacing: 33) {
                        ForEach(TabItem.allCases, id: \.self) { tab in
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.title)
                                Text(tab.rawValue)
                            }
                            .foregroundStyle(selectedTab == tab ? Color("CustomRed") : .white)
                            .onTapGesture {
                                selectedTab = tab
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(tab.rawValue)
                            .accessibilityHint(selectedTab == tab ? "" : "Double-tap to open \(tab.rawValue) view")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onReceive(session.$error) { if let err = $0 { activeError = err} }
        .onReceive(eventsVM.$error) { if let err = $0 { activeError = err} }
        .background {
            Color("background")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    let session = UserSessionViewModel()
    session.currentUser = User(
        uid: "123",
        email: "test@test.com",
        fullname: "Jane Test",
        imageURL: "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/profils_image%2Fdefault-profile-image.jpg?alt=media&token=c9a78295-2ad4-4acf-872d-c193116783c5"
    )
    session.isLoggedIn = true

    let auth = AuthenticationViewModel(session: session)
    auth.authenticationState = .signedIn
    let eventsVM = EventsViewModel()
    return HomeView(session: session, authVM: auth, eventsVM: eventsVM)
}
