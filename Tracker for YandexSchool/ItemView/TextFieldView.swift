//
//  ContentView.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import SwiftUI

struct TextFieldView: View {
    @ObservedObject var taskData: ObservabToDoItem
    
    var body: some View {
        VStack {
            TextField("Что надо сделать?", text: $taskData.taskName, axis: .vertical)
                .lineLimit(5...Int.max)
                .frame(minHeight: 120)
                .padding(16)
                .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

#Preview {
    TextFieldView(taskData: ObservabToDoItem())
}
