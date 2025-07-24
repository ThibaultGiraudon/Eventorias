//
//  AuthenticateView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct AuthenticateView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        VStack {
            Spacer()
            Group {
                Image("logo")
                Image("title")
            }
            .accessibilityHidden(true)
            Button {
                coordinator.goToMail()
            } label: {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Sign in with email")
                }
                .foregroundStyle(.white)
                .padding(10)
                .frame(width: 242)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("CustomRed"))
                }
            }
            .padding(.top, 64)
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
    @Previewable @StateObject var coordinator = AppCoordinator()
    AuthenticateView()
        .environmentObject(coordinator)
}
