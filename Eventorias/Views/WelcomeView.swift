//
//  WelcomeView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI
import Kingfisher

struct WelcomeView: View {
    @ObservedObject var session: UserSessionViewModel
    @ObservedObject var authVM: AuthenticationViewModel

    var body: some View {
        VStack {
            if session.isLoading {
                ProgressView("Loading user...")
            } else if let user = session.currentUser {
                KFImage(URL(string: user.imageURL))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                Text("Welcome \(user.fullname)")

                Button("Log out") {
                    Task {
                        await authVM.signOut()
                    }
                }
                .padding()
            } else {
                Text("Not logged in")
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
    return WelcomeView(session: session, authVM: auth)
}
