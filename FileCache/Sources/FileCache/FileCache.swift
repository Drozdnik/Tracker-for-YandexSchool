import Foundation
import CocoaLumberjackSwift
import SwiftData
import SwiftUI

public enum SortOrder {
    case byCreationDateDescending
    case byPriorityDescending
    case showFinished
    case hideFinished
}
@available(iOS 17, *)
public protocol FileCache {
    func getItems(sortedBy: SortOrder) -> [ToDoItem]
    func addItem(_ item: ToDoItem) throws
    func deleteItem(id: UUID) throws
}

@available(iOS 17, *)
public final class FileCacheImpl: FileCache {
    public private(set) var items: [ToDoItem] = []
    private static let manager = FileManager.default
    private let fileName: String
    private var container: ModelContainer
    
    public init(fileName: String) {
        self.fileName = fileName
        do {
            self.container = try ModelContainer(for: TodoItemModel.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    // ToImprove
    @MainActor public func getItems(sortedBy sortOrder: SortOrder) -> [ToDoItem] {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<TodoItemModel>()
        
        do {
            var results = try context.fetch(fetchDescriptor)
            
            switch sortOrder {
            case .byCreationDateDescending:
                results.sort(by: { $0.createdAt > $1.createdAt })
            case .byPriorityDescending:
                results.sort {
                    let lhsPriority = Priority(rawValue: $0.priorityRawValue)?.order ?? 0
                    let rhsPriority = Priority(rawValue: $1.priorityRawValue)?.order ?? 0
                    if lhsPriority == rhsPriority {
                        return $0.createdAt > $1.createdAt
                    }
                    return lhsPriority > rhsPriority
                }
            case .showFinished:
                _ = results
            case .hideFinished:
                results = results.filter { !$0.isCompleted }
            }
            
            return results.map { ToDoItem(from: $0) }
        } catch {
            DDLogError("Failed to fetch todo items: \(error)")
            return []
        }
    }
    
    
    
    @MainActor public func addItem(_ item: ToDoItem) throws {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<TodoItemModel>()
        
        do {
            let results = try context.fetch(fetchDescriptor)
            
            if let existingItem = results.first(where: { $0.id == item.id.uuidString }) {
                existingItem.text = item.text
                existingItem.priorityRawValue = item.priority.rawValue
                existingItem.deadline = item.deadLine
                existingItem.isCompleted = item.flag
                existingItem.changeAt = item.changedAt ?? item.createdAt
                existingItem.hexColor = item.pickedColor?.toHex()
                existingItem.category = item.category?.name
            } else {
                let todoModel = TodoItemModel(from: item)
                context.insert(todoModel)
            }
            try context.save()
        } catch {
            DDLogError("Failed to add or update todo item: \(error)")
            throw FileCacheError.savingError
        }
    }
    
    @MainActor public func deleteItem(id: UUID) throws {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<TodoItemModel>(
            predicate: #Predicate { $0.id == id.uuidString }
        )
        
        do {
            if let itemToDelete = try context.fetch(fetchDescriptor).first {
                context.delete(itemToDelete)
                try context.save()
            } else {
                throw FileCacheError.itemNotFound
            }
        } catch {
            DDLogError("Failed to delete todo item: \(error)")
            throw FileCacheError.deleteError
        }
    }
}

extension ToDoItem {
    @available(iOS 17, *)
    init(from model: TodoItemModel) {
        self.id = UUID(uuidString: model.id) ?? UUID()
        self.text = model.text
        self.priority = Priority(rawValue: model.priorityRawValue) ?? .basic
        self.deadLine = model.deadline
        self.flag = model.isCompleted
        self.createdAt = model.createdAt
        self.changedAt = model.changeAt
        self.pickedColor = Color(hex: model.hexColor ?? "#000000")
        self.category = model.category.map { Categories(name: $0, color: Color(hex: model.hexColor ?? "#000000")) }
    }
}
