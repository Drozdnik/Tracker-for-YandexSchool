//
//  DeleteButton.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 22.06.2024.
//

import SwiftUI

struct DeleteButtonView: View {
    var body: some View {
        
        Button(action: {
                }) {
                    Text("Удалить")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                }
    }
}

#Preview {
    DeleteButtonView()
}
