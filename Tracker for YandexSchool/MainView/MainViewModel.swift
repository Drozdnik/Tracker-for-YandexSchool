import SwiftUI

final class MainViewModel: ObservableObject{
     private let fileCache: FileCache
    
    @Published var items: [ToDoItem] = []
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func getItems() {
       items = fileCache.getItems()
    }
}
