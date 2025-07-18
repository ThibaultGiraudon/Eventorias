//
//  RegisterView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authVM: AuthenticationViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var shouldDisable: Bool {
        authVM.email.isEmpty || authVM.password.isEmpty || authVM.fullname.count < 4
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
            Image("title")
            .padding(.bottom, 64)
            Group {
                TextField(text: $authVM.email) {
                    Text("Email")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(10)
                .background(Color("CustomGray"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                TextField(text: $authVM.fullname) {
                    Text("Fullname")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(10)
                .background(Color("CustomGray"))
                SecureField(text: $authVM.password) {
                    Text("Password")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(10)
                .background(Color("CustomGray"))
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
            .foregroundStyle(.white)
            Button {
                Task {
                    do {
                        try await authVM.register()
                        coordinator.resetNavigation()
                    } catch {
                        
                    }
                }
            } label: {
                Text("Create an account")
                .foregroundStyle(shouldDisable ? .gray : .red)
                .padding(10)
                .frame(width: 242)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 2)
                        .fill(shouldDisable ? .gray : .red)
                }
            }
            .disabled(shouldDisable)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom, content: {
            if let error = authVM.error {
                Text(error)
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .foregroundStyle(.white)
            }
        })
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
    return RegisterView(authVM: auth)
}
