//
//  HomeView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            if authViewModel.isLoggedIn {
                WelcomeView()
            } else {
                AuthenticateView()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var authViewModel = AuthViewModel()
    NavigationStack {
        HomeView()
            .environmentObject(authViewModel)
    }
}
