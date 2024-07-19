import SwiftUI
import FileCache


final class MainViewModel: ObservableObject {
    private let fileCache: FileCache
    private let networkManager: NetworkManager
    
    @Published var items: [ToDoItem] = []
    @Published var showFinished: Bool = true
    @Published var sortByPriority: Bool = true
    @Published var finishedTasks: Int = 0
    
    init(fileCache: FileCache, networkManager: NetworkManager) {
        self.fileCache = fileCache
        self.networkManager = networkManager
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
    
    func loadToDoList() {
        Task {
            await networkManager.getToDoList { [weak self] items, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Failed to fetch ToDo list: \(error)")
                } else if let items = items {
                    DispatchQueue.main.sync {
                        self.items = items
                        for item in items {
                            self.fileCache.addItem(item)
                        }
                        print("Fetched ToDo list with \(items.count) items")
                        self.getItems()
                    }
                }
            }
        }
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
