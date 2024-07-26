import Foundation
import SwiftData

@available(iOS 17, *)
@Model
public final class TodoItemModel {
    @Attribute(.unique)
    var id: String

    @Attribute(originalName: "created_at")
    var createdAt: Date

    var priority: Priority {
        Priority(rawValue: priorityRawValue) ?? .basic
    }
    @Attribute(originalName: "priority")
    var priorityRawValue: String

    @Attribute(originalName: "change_at")
    var changeAt: Date

    var isCompleted: Bool
    var text: String
    var deadline: Date?
    var hexColor: String?
    var category: String?
    var lastUpdatedBy: String?

    init(
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
