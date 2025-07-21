//
//  ProfileImageView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ProfileImageView: View {
    @ObservedObject var session: UserSessionViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var showPhotosPicker: Bool = false
    
    var body: some View {
        if let user = session.currentUser {
            VStack {
                    KFImage(URL(string: user.imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 100)
                        .clipped()
                        .clipShape(Circle())
                        .id(user.imageURL)
                        .onTapGesture {
                            showPhotosPicker = true
                        }
            }
            .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            selectedItem = nil
                            await session.uploadImage(uiImage)
                        }
                    }
                }
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
    
    return  ProfileImageView(session: session)
}
