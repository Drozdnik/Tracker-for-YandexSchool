import SwiftUI

final class MainViewModel: ObservableObject {
     private let fileCache: FileCache
    
    @Published var items: [ToDoItem] = [ToDoItem(text: "Первый итем", priority: .normal), ToDoItem(text: "Второй", priority: .low), ToDoItem(text: "Третий", priority: .high)]
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func getItems() {
       items = fileCache.getItems()
    }
    
    func toogleFlag(for itemID: UUID) {
        if let index = items.firstIndex(where: {$0.id == itemID}){
            let updatedItem = items[index]
            fileCache.addItem(updatedItem)
        }
    }
}
