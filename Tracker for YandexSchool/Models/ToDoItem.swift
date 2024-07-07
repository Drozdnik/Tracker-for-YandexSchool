import SwiftUI

protocol ToDoItemParseProtocol {
    var json: Any {get}
    
    static func parse(json: Any) -> Self?
    static func parseCSV(csvString: String) -> [Self]
}

struct ToDoItem {
    let id: UUID
    let text: String
    let priority: Priority
    let deadLine: Date?
    let flag: Bool
    let createdAt: Date
    let changedAt: Date?
    let pickedColor: Color?
    let category: Categories?
    
    init(
        id: UUID? = nil,
        text: String,
        priority: Priority,
        deadLine: Date? = nil,
        flag: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date? = nil,
        pickedColor: Color? = nil,
        category: Categories? = nil
    ) {
        self.id = id ?? UUID()
        self.text = text
        self.priority = priority
        self.deadLine = deadLine
        self.flag = flag
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.pickedColor = pickedColor
        self.category = category
    }
}
