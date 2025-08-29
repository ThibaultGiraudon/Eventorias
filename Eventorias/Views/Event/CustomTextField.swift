//
//  CustomTextField.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 17/07/2025.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var label: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(.gray)
            TextField(text: $text) {
                Text(label)
                    .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
            .font(.title3)
            .accessibilityIdentifier(title)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color("CustomGray"))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(label)
    }
}

#Preview {
    CustomTextField(title: "Name", label: "Enter your name", text: .constant("Charles Leclerc"))
}
