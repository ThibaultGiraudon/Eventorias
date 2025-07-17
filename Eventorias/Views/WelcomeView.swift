//
//  WelcomeView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            if let url = URL(string: authViewModel.user.imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .padding()
                Text("Welcome \(authViewModel.user.fullname)")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Log out") {
                                authViewModel.signOut()
                            }
                        }
                    }
            } else {
                Text("CPT")
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var authViewModel = AuthViewModel()
    WelcomeView()
        .environmentObject(authViewModel)
}
