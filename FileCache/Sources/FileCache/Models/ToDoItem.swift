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
        case id, text, done, color
        case priority = "importance"
        case deadLine = "deadline"
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
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
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        changedAt = try? container.decode(Date.self, forKey: .changedAt)
        flag = ((try? container.decode(Bool.self, forKey: .done)) != false)
        category = nil
        
        if let colorString = try container.decodeIfPresent(String.self, forKey: .color) {
                pickedColor = Color(hex: colorString)
            } else {
                pickedColor = nil
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
