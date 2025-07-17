//
//  RegisterView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
            Image("title")
            .padding(.bottom, 64)
            Group {
                TextField(text: $authViewModel.email) {
                    Text("Email")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(10)
                .background(Color("CustomGray"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                TextField(text: $authViewModel.fullname) {
                    Text("Fullname")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(10)
                .background(Color("CustomGray"))
                SecureField(text: $authViewModel.password) {
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
                authViewModel.register {
                    coordinator.resetNavigation()
                }
            } label: {
                Text("Create an account")
                .foregroundStyle(.red)
                .padding(10)
                .frame(width: 242)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 2)
                        .fill(.red)
                }
            }
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("background")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    @Previewable @StateObject var authViewModel = AuthViewModel()
    @Previewable @StateObject var coordinator = AppCoordinator()
    RegisterView()
        .environmentObject(authViewModel)
        .environmentObject(coordinator)
}
