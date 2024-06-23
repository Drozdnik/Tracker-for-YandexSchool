import Foundation

protocol ToDoItemParseProtocol {
    var json: Any {get}
    
    static func parse(json: Any) -> Self?
    static func parseCSV(csvString: String) -> [Self]
}

struct ToDoItem {
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


