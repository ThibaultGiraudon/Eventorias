//
//  ProfileView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var session: UserSessionViewModel
    @ObservedObject var authVM: AuthenticationViewModel
    @State private var fullname: String
    @State private var email: String
    @State private var selectedEvents: EventsType = .created
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

    @EnvironmentObject var coordinator: AppCoordinator
    
    var shouldDisable: Bool {
        (fullname == session.currentUser?.fullname && email == session.currentUser?.email) || fullname.isEmpty || email.isEmpty
    }
    
    init(session: UserSessionViewModel, authVM: AuthenticationViewModel) {
        self.session = session
        self.fullname = session.currentUser?.fullname ?? ""
        self.email = session.currentUser?.email ?? ""
        self.authVM = authVM
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
                Toggle(isOn: $notificationsEnabled) {
                    Text("Notifications")
                }
                .tint(Color("CustomRed"))
                .foregroundStyle(.white)
                .padding(.vertical)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Notification toggle")
                .accessibilityHint("Double-tap to \(notificationsEnabled ? "disable" : "enable") notifications")
                Spacer()
                HStack {
                    Button {
                        Task {
                            await authVM.signOut()
                        }
                    } label: {
                        Text("Log Out")
                            .font(.title2)
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                            }
                            .padding()
                    }
                    .accessibilityHint("Double-tap to log out")
                    Button {
                        Task {
                            await session.updateUser(email: email, fullname: fullname)
                        }
                    } label: {
                        Group {
                            if session.isLoading {
                                ProgressView()
                            } else {
                                Text("Save")
                            }
                        }
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
                    .accessibilityHint(shouldDisable ? "Button disable, fill out all the fields" : "Double-tap to save changes")
                }
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
    
    return ProfileView(session: session, authVM: AuthenticationViewModel(session: session))
}
