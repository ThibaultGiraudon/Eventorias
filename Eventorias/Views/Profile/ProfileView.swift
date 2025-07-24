//
//  ProfileView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @ObservedObject var session: UserSessionViewModel
    @State private var fullname: String
    @State private var email: String
    @State private var selectedEvents: EventsType = .created
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var shouldDisable: Bool {
        (fullname == session.currentUser?.fullname && email == session.currentUser?.email) || fullname.isEmpty || email.isEmpty
    }
    
    init(session: UserSessionViewModel) {
        self.session = session
        self.fullname = session.currentUser?.fullname ?? ""
        self.email = session.currentUser?.email ?? ""
    }
    var body: some View {
        if session.currentUser != nil {
            VStack {
                HStack {
                    Text("User profile")
                        .foregroundStyle(.white)
                        .font(.title)
                    Spacer()
                    ProfileImageView(session: session)
                }
                CustomTextField(title: "Name", label: "", text: $fullname)
                    .padding(.bottom, 24)
                CustomTextField(title: "E-mail", label: "", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                HStack {
                    Text("My events")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background {
                            Capsule()
                                .fill(Color("CustomGray").opacity(selectedEvents == .created ? 1.0 : 0.5))
                        }
                        .onTapGesture {
                            selectedEvents = .created
                        }
                    
                    Text("Subsribed events")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background {
                            Capsule()
                                .fill(Color("CustomGray").opacity(selectedEvents == .subscribed ? 1.0 : 0.5))
                        }
                        .onTapGesture {
                            selectedEvents = .subscribed
                        }
                }
                .foregroundStyle(.white)
                .padding(.top, 22)
                switch selectedEvents {
                case .created:
                    ScrollView(showsIndicators: false) {
                        ForEach(session.createdEvents) { event in
                            EventRowView(event: event)
                                .onTapGesture {
                                    coordinator.goToDetailView(for: event)
                                }
                        }
                    }
                case .subscribed:
                    ScrollView(showsIndicators: false) {
                        ForEach(session.subscribedEvents) { event in
                            EventRowView(event: event)
                                .onTapGesture {
                                    coordinator.goToDetailView(for: event)
                                }
                        }
                    }
                }
                Spacer()
                Button {
                    Task {
                        await session.updateUser(email: email, fullname: fullname)
                    }
                } label: {
                    Text("Save change")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("CustomRed").opacity(shouldDisable ? 0.6 : 1.0))
                        }
                        .padding()
                }
                .disabled(shouldDisable)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color("background")
                    .ignoresSafeArea()
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
    
    return ProfileView(session: session)
}
