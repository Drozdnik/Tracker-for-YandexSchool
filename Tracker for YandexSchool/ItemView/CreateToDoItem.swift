//
//  CreateToDoItem.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 22.06.2024.
//

import SwiftUI

struct CreateToDoItem: View {
    @ObservedObject var taskData: ObservabToDoItem

    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                TextFieldView(taskData: taskData)
                    .padding(.horizontal)
                
                ImportanceListView(taskData: taskData)
                    .padding(.horizontal)
                
                DeleteButtonView()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .background(Color.backgroundColor)
        }
    }
}

#Preview {
    CreateToDoItem(taskData: ObservabToDoItem())
}
