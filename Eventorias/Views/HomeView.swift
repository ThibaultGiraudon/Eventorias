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
    @State private var selectedTab: TabItem = .events
    var body: some View {
        VStack {
            switch authVM.authenticationState {
            case .signedOut:
                AuthenticateView()
            case .signingIn:
                ProgressView()
            case .signedIn:
                VStack {
                    switch selectedTab {
                    case .events:
                        EventsListView(eventsVM: eventsVM)
                    case .profile:
                        ProfileView(session: session)
                    }
                    HStack(spacing: 33) {
                        ForEach(TabItem.allCases, id: \.self) { tab in
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.title)
                                Text(tab.rawValue)
                            }
                            .foregroundStyle(selectedTab == tab ? .red : .white)
                            .onTapGesture {
                                selectedTab = tab
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background {
                        Color("background")
                            .ignoresSafeArea()
                    }
                }
            }
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
    let eventsVM = EventsViewModel()
    return HomeView(session: session, authVM: auth, eventsVM: eventsVM)
}
