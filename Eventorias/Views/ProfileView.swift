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
    
    var shouldDisable: Bool {
        (fullname == session.currentUser?.fullname && email == session.currentUser?.email) || fullname.isEmpty || email.isEmpty
    }
    
    init(session: UserSessionViewModel) {
        self.session = session
        self.fullname = session.currentUser?.fullname ?? ""
        self.email = session.currentUser?.email ?? ""
    }
    var body: some View {
        if let user = session.currentUser {
            VStack {
                HStack {
                    Text("User profile")
                        .foregroundStyle(.white)
                        .font(.title)
                    Spacer()
                    KFImage(URL(string: user.imageURL))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                CustomTextField(title: "Name", label: "", text: $fullname)
                    .padding(.bottom, 24)
                CustomTextField(title: "E-mail", label: "", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Spacer()
                Button {
                    Task {
                        await session.updateUser(email: email, fullname: fullname, imageURL: user.imageURL)
                    }
                } label: {
                    Text("Save chage")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.red.opacity(shouldDisable ? 0.6 : 1.0))
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
