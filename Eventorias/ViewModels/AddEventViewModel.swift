//
//  AddEventViewModel.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 21/07/2025.
//

import Foundation
import SwiftUI

class AddEventViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: String = ""
    @Published var hour: String = ""
    @Published var address: String = ""
    @Published var uiImage: UIImage?
    @Published var error: String?
    
    var shouldDisable: Bool {
        title.isEmpty || description.isEmpty || date.isEmpty || hour.isEmpty || address.isEmpty || uiImage == nil
    }

    private let eventRepository: EventsRepository = .init()
    private let storageRepository: StorageRepository = .init()
    private let session: UserSessionViewModel
    
    init(session: UserSessionViewModel) {
        self.session = session
    }
    
    @MainActor
    func addEvent() async {
        self.error = nil
        guard let date = self.date.toDate(), let hour = self.hour.toHour() else {
            self.error = "Bad date format."
            print("date error")
            return
        }
        
        guard let uiImage = self.uiImage else {
            self.error = "Can't find image."
            print("image error")
            return
        }
        
        guard let user = session.currentUser else {
            self.error = "User not logged in."
            print("user error")
            return
        }
        
        do {
            let url = try await storageRepository.uploadImage(uiImage, to: "/events/")
            let event = Event(title: title,
                              descrition: description,
                              date: date,
                              hour: hour,
                              imageURL: url,
                              address: address,
                              location: .init(latitude: 0, longitude: 0),
                              creatorID: user.uid)
            try eventRepository.setEvent(event)
        } catch {
            self.error = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}
