import SwiftUI



public struct ToDoItem: Decodable {
    public let id: UUID
    public let text: String
    public let priority: Priority
    public let deadLine: Date?
    public let flag: Bool
    public let createdAt: Date
    public let changedAt: Date?
    public let pickedColor: Color?
    public let category: Categories?
    
    enum CodingKeys: String, CodingKey {
        case id, text, priority, flag, createdAt, changedAt, pickedColor, category
        case deadLine = "deadline"
    }
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        priority = try container.decode(Priority.self, forKey: .priority)
        deadLine = try? container.decode(Date.self, forKey: .deadLine)
        flag = try container.decode(Bool.self, forKey: .flag)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        changedAt = try? container.decode(Date.self, forKey: .changedAt)
        pickedColor = nil
        category = nil
    }
}
