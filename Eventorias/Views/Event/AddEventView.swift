//
//  AddEventView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI
import PhotosUI
import MapKit

struct AddEventView: View {
    @ObservedObject var viewModel: AddEventViewModel
    @State private var showPhotosPicker: Bool = false
    @State private var isCameraPresented: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @EnvironmentObject var coordinator: AppCoordinator
    @FocusState private var focused
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrow.left")
                    .onTapGesture {
                        coordinator.dismiss()
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityHint("Double-tap to go back")
                    .disabled(viewModel.isLoading)
                Text("Creation of an event")
                Spacer()
            }
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.leading, 16)
            .padding(.vertical, 24)
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(title: "Title", label: "New event", text: $viewModel.title)
                    CustomTextField(title: "Description", label: "Tap here to enter your description", text: $viewModel.description)
                    HStack(spacing: 16) {
                        CustomTextField(title: "Date", label: "MM/DD/YYYY", text: $viewModel.date)
                        CustomTextField(title: "Time", label: "HH:MM", text: $viewModel.hour)
                    }
                    CustomTextField(title: "Address", label: "Enter full address", text: $viewModel.address)
                        .focused($focused)
                        .onChange(of: focused) {
                            if !focused {
                                Task {
                                    await viewModel.geocodeAddress()
                                }
                            }
                        }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 48)
                if let location = viewModel.location {
                    GoogleMapView(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    .frame(height: 200)
                    .accessibilityElement()
                    .accessibilityLabel("Map")
                    .accessibilityValue("Centered on \(viewModel.address)")
                }
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Camera button")
                        .accessibilityHint("Double-tap to take a picture")
                    
                    Image(systemName: "paperclip")
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(-45))
                        .padding(16)
                        .frame(width: 52, height: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("CustomRed"))
                        }
                        .onTapGesture {
                            showPhotosPicker = true
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Gallery button")
                        .accessibilityHint("Double-tap to import a picture")
                }
                if let image = viewModel.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .accessibilityElement(children: .ignore)
                }
            }
            Spacer()
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
        .overlay(alignment: .bottom, content: {
            if let error = viewModel.error {
                Text(error)
                    .frame(maxWidth: .infinity)
                    .background(Color("CustomRed"))
                    .foregroundStyle(.white)
                    .onAppear {
                        UIAccessibility.post(notification: .announcement, argument: error)
                    }
            }
        })
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
        .toolbarVisibility(.hidden)
        .navigationBarBackButtonHidden()
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
    
    return AddEventView(viewModel: AddEventViewModel(session: session))
}
