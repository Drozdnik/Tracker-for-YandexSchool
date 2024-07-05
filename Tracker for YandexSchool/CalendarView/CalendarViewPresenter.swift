import Foundation

final class CalendarViewPresenter {
    private var groupedItems: [String: [ToDoItem]] = [:]
    var sortedDates: [String] = []
    var onUpdateCollection: (() -> Void)?
    var onUpdateTable: (() -> Void)?
    let fileCache: FileCache
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func loadData() {
        let items = fileCache.getItems()
        
        groupedItems.removeAll()
        
        for item in items {
            let key = item.deadLine.map { DateFormatter.dayMonth.string(from: $0) } ?? "Другое"
            groupedItems[key, default: []].append(item)
        }
        
        sortedDates = groupedItems.keys.sorted()
    }
    
    func numberOfSections() -> Int {
        return sortedDates.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedItems[dateKey]?.count ?? 0
    }
    
    
    func titleForHeaderInSection(section: Int) -> String {
        return sortedDates[section]
    }
    
    func getItem(at indexPath: IndexPath) -> ToDoItem? {
        let dateKey = sortedDates[indexPath.section]
        return groupedItems[dateKey]?[indexPath.row]
    }
    
    func toggleCompletion(at indexPath: IndexPath) {
            guard let item = getItem(at: indexPath) else { return }
            let updatedItem = ToDoItem(
                id: item.id,
                text: item.text,
                priority: item.priority,
                deadLine: item.deadLine,
                flag: !item.flag,
                createdAt: item.createdAt,
                changedAt: Date(),
                pickedColor: item.pickedColor,
                category: item.category
            )
            
            fileCache.addItem(updatedItem)
        loadData()
        onUpdateTable?()
        }
}
