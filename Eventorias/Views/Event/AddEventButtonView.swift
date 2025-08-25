//
//  AddEventButtonView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 25/08/2025.
//

import SwiftUI

struct AddEventButtonView: View {
    @ObservedObject var viewModel: AddEventViewModel
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Button {
            Task {
                await viewModel.addEvent()
                if viewModel.error == nil {
                    UIAccessibility.post(notification: .announcement, argument: "Successfuly added new event")
                    coordinator.dismiss()
                }
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Validate")
                }
            }
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("CustomRed").opacity(viewModel.shouldDisable ? 0.6 : 1.0))
                }
                .padding()
        }
        .disabled(viewModel.shouldDisable)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Validate button")
        .accessibilityHint(viewModel.shouldDisable ? "Button disable, fill out all the fields" : "Double-tap to sign in")
    }
}
