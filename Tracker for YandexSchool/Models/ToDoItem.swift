//
//  ToDoItem.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import Foundation
protocol ToDoItemParceProtocol{
    var json: Any {get}
    //Вот тут наверное окей использовать self? (может только название протокола поменять) тк можем, если что подменить структуру
    static func parse(json: Any) -> Self?
}

struct ToDoItem{
    let id: String
    let text: String
    let priority: Priority
    let deadLine: Date?
    let flag: Bool
    let createdAt: Date
    let changedAt: Date?
    init(
        id: String? = nil,
         text: String,
         priority: Priority,
         deadLine: Date? = nil,
         flag: Bool = false,
         createdAt: Date = Date(),
         changedAt: Date? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.priority = priority
        self.deadLine = deadLine
        self.flag = flag
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}


