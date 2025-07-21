//
//  AddEventView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI
import PhotosUI

struct AddEventView: View {
    @ObservedObject var viewModel: AddEventViewModel
    @State private var showPhotosPicker: Bool = false
    @State private var isCameraPresented: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(title: "Title", label: "New event", text: $viewModel.title)
                    CustomTextField(title: "Description", label: "Tap here to enter your description", text: $viewModel.title)
                    HStack(spacing: 16) {
                        CustomTextField(title: "Date", label: "MM/DD/YYYY", text: $viewModel.date)
                        CustomTextField(title: "Time", label: "HH:MM", text: $viewModel.hour)
                    }
                    CustomTextField(title: "Address", label: "Enter full address", text: $viewModel.title)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 48)
                HStack(spacing: 16) {
                    Image(systemName: "camera")
                        .foregroundStyle(.black)
                        .padding(16)
                        .frame(width: 52, height: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                        }
                        .onTapGesture {
                            isCameraPresented = true
                        }
                    
                    Image(systemName: "paperclip")
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(-45))
                        .padding(16)
                        .frame(width: 52, height: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.red)
                        }
                        .onTapGesture {
                            showPhotosPicker = true
                        }
                }
                if let image = viewModel.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }
            Spacer()
            Button {
                
            } label: {
                Text("Validate")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.red.opacity(viewModel.shouldDisable ? 0.6 : 1.0))
                    }
                    .padding()
            }
            .disabled(viewModel.shouldDisable)
        }
        .background {
            Color("background")
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraPicker(image: $viewModel.uiImage)
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    viewModel.uiImage = UIImage(data: data)
                    selectedItem = nil
                }
            }
        }
    }
}

#Preview {
    AddEventView(viewModel: AddEventViewModel())
}
