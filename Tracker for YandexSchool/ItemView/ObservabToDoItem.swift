//
//  ObservabToDoItem.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 22.06.2024.
//

import SwiftUI

class ObservabToDoItem: ObservableObject {
    @Published var taskName: String = ""
    @Published var selectedIcon: SwitchcerViewElementEnum = .text("нет")
    @Published var dueDate: Date = Date()
    @Published var deadLineActivate: Bool = false
}
