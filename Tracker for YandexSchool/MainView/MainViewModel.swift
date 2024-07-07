import SwiftUI

final class MainViewModel: ObservableObject {
    private let fileCache: FileCache
    
    @Published var items: [ToDoItem] = []
    @Published var showFinished: Bool = true
    @Published var sortByPriority: Bool = true
    @Published var finishedTasks: Int = 0
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func getItems() {
        items = fileCache.getItems()
        filterTasks()
        sortTasks()
    }
    
    func findFinishedTasks() {
        finishedTasks = items.filter { $0.flag }.count
    }
    
    func toogleFlag(for itemID: UUID) {
        if let index = items.firstIndex(where: {$0.id == itemID}) {
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
            getItems()
            findFinishedTasks()
        }
    }
    
    func deleteItem(for item: Int) {
        let itemID = items[item].id
        do {
            try fileCache.deleteItem(id: itemID)
            getItems()
        } catch {
            assertionFailure("Item с id \(itemID) не найден")
        }
    }
    
    func toggleShowFinished() {
        showFinished.toggle()
        getItems()
        filterTasks()
    }
    
    func toggleSortPreference() {
        sortByPriority.toggle()
        getItems()
        sortTasks()
    }
    
    private func filterTasks() {
        if !showFinished {
            items = items.filter { !$0.flag }
        }
    }
    
    private func sortTasks() {
        if sortByPriority {
            items.sort { $0.priority > $1.priority }
        } else {
            items.sort { $0.createdAt < $1.createdAt }
        }
    }
}
