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
    
    var shouldDisable: Bool {
        title.isEmpty || description.isEmpty || date.isEmpty || hour.isEmpty || address.isEmpty || uiImage == nil
    }
}
