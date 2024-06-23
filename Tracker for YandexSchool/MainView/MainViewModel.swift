import SwiftUI

final class MainViewModel: ObservableObject {
    private let fileCache: FileCache
    
    @Published var items: [ToDoItem] = [ToDoItem(text: "Первый итем", priority: .normal), ToDoItem(text: "Второй", priority: .low), ToDoItem(text: "Третий", priority: .high), ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),ToDoItem(text: "Первый итем", priority: .normal),]
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func getItems() {
        items = fileCache.getItems()
    }
    
    func toogleFlag(for itemID: UUID) {
        if let index = items.firstIndex(where: {$0.id == itemID}){
            let updatetItem = items[index]
            let newItem = ToDoItem(
                id: updatetItem.id,
                text: updatetItem.text,
                priority: updatetItem.priority,
                deadLine: updatetItem.deadLine,
                flag: !updatetItem.flag,
                createdAt: updatetItem.createdAt,
                changedAt: updatetItem.changedAt
            )
            
            fileCache.addItem(newItem)
            items = fileCache.getItems()
        }
    }
}
