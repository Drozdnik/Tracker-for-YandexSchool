import Foundation
import CocoaLumberjackSwift

protocol FileCache {
    func getItems() -> [ToDoItem]
    func addItem(_ item: ToDoItem)
    func deleteItem(id: UUID) throws
    func saveToFile() throws
    func loadFromFile() throws
}

final class FileCacheImpl: FileCache {
    private(set) var items: [ToDoItem] = []
    private static let manager = FileManager.default
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func getItems() -> [ToDoItem] {
        return items
    }
    
    func addItem(_ item: ToDoItem) {
        for index in 0..<items.count where items[index].id == item.id {
            items[index] = item
            return
        }
        DDLogInfo("Добавление элемента: \(item.text) с ID: \(item.id.uuidString)")
        items.append(item)
    }
    
    func deleteItem(id: UUID) throws {
        guard items.contains(where: { $0.id == id }) else {
            throw FileCacheError.itemNotFound
        }
        items.removeAll(where: { $0.id == id })
    }
    
    func saveToFile() throws {
        do {
            let json = try JSONSerialization.data(withJSONObject: items.map({$0.json}))
            let url = try getUrlForManager()
            try json.write(to: url)
        } catch {
            assertionFailure("Save to file error")
            throw FileCacheError.savingError
        }
    }
    
    func loadFromFile() throws {
        do {
            let url = try getUrlForManager()
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [[String : Any]] {
                items = json.compactMap({ToDoItem.parse(json: $0)})
            }
        } catch {
            assertionFailure("Load from file error")
            throw FileCacheError.loadingError
        }
    }
    
    private func getUrlForManager() throws -> URL {
        guard let url = FileCacheImpl.manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.urlCreationError
        }
        return url.appendingPathComponent(fileName)
    }
}
