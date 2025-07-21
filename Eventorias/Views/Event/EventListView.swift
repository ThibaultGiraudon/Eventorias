//
//  EventListView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
            }
        }
        .background {
            Color("background")
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                coordinator.goToAddEvent()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.red)
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    EventListView()
}
