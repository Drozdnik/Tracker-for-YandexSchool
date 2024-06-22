//
//  ContentView.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var taskName: String = ""
    @State private var textEditorHeight: CGFloat = 120
    
    var body: some View {
        VStack {
            TextField("Что надо сделать?", text: $taskName, axis: .vertical)
                .lineLimit(5...Int.max)
                .frame(minHeight: textEditorHeight)
                .padding(16)
                .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding()
        
        Spacer()
    }
}

#Preview {
    ContentView()
}
