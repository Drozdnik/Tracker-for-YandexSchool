import SwiftUI
import FileCache
import CocoaLumberjackSwift

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
    
    func deleteItem(for id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            assertionFailure("Item с id \(id) не найден")
            return
        }
        
        let item = items[index]
        
        do {
            try fileCache.deleteItem(id: item.id)
        } catch {
            print("Ошибка при удалении элемента из кеша: \(error)")
        }
        
        items.remove(at: index)
        
        Task {
            await deleteItemNetwork(id: item.id)
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
            await networkManager.networkRequest(with: .getList) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        self.items = response.list
                        for item in response.list {
                            self.fileCache.addItem(item)
                        }
                        print("Fetched ToDo list with \(response.list.count) items")
                        self.getItems()
                        
                    case .failure(let error):
                        print("Failed to fetch ToDo list: \(error)")
                    }
                }
            }
        }
    }
    
    func deleteItemNetwork(id: UUID) {
        Task {
            networkManager.synchronizeIfNeeded { [weak self] synchronizedItems in
                guard let self = self else { return }
                if let synchronizedItems {
                    for item in synchronizedItems {
                        fileCache.addItem(item)
                    }
                    self.performDeleteItemNetwork(id: id)
                } else {
                    self.performDeleteItemNetwork(id: id)
                }
            }
        }
    }
    
    
    private func performDeleteItemNetwork(id: UUID) {
        Task {
            await networkManager.networkRequest(with: .deleteElement(id: id, revision: networkManager.revision)) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        DDLogInfo("Successfully deleted item with id: \(id)")
                        
                    case .failure(let error):
                        DDLogWarn("Failed to delete item with id: \(id) with \(error)")
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
