import SwiftUI

public protocol ToDoItemParseProtocol {
    var json: Any { get }
    
    static func parse(json: Any) -> Self?
    static func parseCSV(csvString: String) -> [Self]
}

public struct ToDoItem {
    public let id: UUID
    public let text: String
    public let priority: Priority
    public let deadLine: Date?
    public let flag: Bool
    public let createdAt: Date
    public let changedAt: Date?
    public let pickedColor: Color?
    public let category: Categories?
    
    public init(
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
