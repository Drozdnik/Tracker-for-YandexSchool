import Foundation
import SwiftData

@available(iOS 17, *)
@Model
public final class TodoItemModel {
    @Attribute(.unique)
    public var id: String

    @Attribute(originalName: "created_at")
    public var createdAt: Date

    public var priority: Priority {
        Priority(rawValue: priorityRawValue) ?? .basic
    }
    @Attribute(originalName: "priority")
    public var priorityRawValue: String

    @Attribute(originalName: "change_at")
    public var changeAt: Date

    public var isCompleted: Bool
    public var text: String
    public var deadline: Date?
    public var hexColor: String?
    public var category: String?
    public var lastUpdatedBy: String?

    public init(
        id: String,
        text: String,
        createdAt: Date,
        isCompleted: Bool,
        priorityRawValue: String,
        deadline: Date?,
        changeAt: Date,
        hexColor: String?,
        category: String?,
        lastUpdatedBy: String?
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.priorityRawValue = priorityRawValue
        self.deadline = deadline
        self.changeAt = changeAt
        self.hexColor = hexColor
        self.category = category
        self.lastUpdatedBy = lastUpdatedBy
    }
}

@available(iOS 17, *)
extension TodoItemModel {
    convenience init(from item: ToDoItem) {
        self.init(
            id: item.id.uuidString,
            text: item.text,
            createdAt: item.createdAt,
            isCompleted: item.flag,
            priorityRawValue: item.priority.rawValue,
            deadline: item.deadLine,
            changeAt: item.changedAt ?? item.createdAt,
            hexColor: item.pickedColor?.toHex(),
            category: item.category?.name,
            lastUpdatedBy: nil
        )
    }
}
