//
//  ErrorView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 23/07/2025.
//

import SwiftUI

struct ErrorView: View {
    var error: String
    var tryAgain: () -> Void
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark")
                .font(.largeTitle)
                .padding(20)
                .background {
                    Circle()
                        .fill(Color("CustomGray"))
                }
                .padding(.bottom, 24)
            
            Text("Error")
                .font(.title2.bold())
                .padding(.bottom, 5)
            Text("An error has occured while:")
            Text(error)
                .bold()
            Text("please try again later")
            
            Button(action: tryAgain) {
                Text("Try again")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("CustomRed"))
                    }
            }
            .padding(.top, 35)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background {
            Color("background")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ErrorView(error: "creating a new event") {
        
    }
}
