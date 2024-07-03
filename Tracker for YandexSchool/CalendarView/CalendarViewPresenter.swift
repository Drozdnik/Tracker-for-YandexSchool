import Foundation

final class CalendarViewPresenter {
    private var groupedItems: [String: [String]] = [:]
    var sortedDates: [String] = []
    var onUpdate: (() -> Void)?
    let fileCache: FileCache
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func loadData() {
        let items = fileCache.getItems()
        
        for item in items {
            if let deadLine = item.deadLine {
                let key = DateFormatter.dayMonth.string(from: deadLine)
                groupedItems[key, default: []].append(item.text)
            } else {
                groupedItems["Другое", default: []].append(item.text)
            }
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
    
    func textForItem(at indexPath: IndexPath) -> String? {
        let dateKey = sortedDates[indexPath.section]
        return groupedItems[dateKey]?[indexPath.row]
    }
}
