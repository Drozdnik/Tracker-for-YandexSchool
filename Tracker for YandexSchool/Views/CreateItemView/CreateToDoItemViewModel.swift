import SwiftUI
import FileCache
final class CreateToDoItemViewModel: ObservableObject {
    private let fileCache: FileCache
    private var changedItem: ToDoItem?
    private var changedAt: Date?
    private let tomorrow: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    @Published var taskName: String = ""
    @Published var selectedIcon: SwitchcerViewElementEnum = .text("нет")
    @Published var deadLine: Date?
    @Published var datePickerIsShown: Bool = false
    @Published var pickedColor: Color? 
    @Published var colorPickerIsShown: Bool = false
    @Published var colorPickerActivate: Bool = false
    @Published var selectedCategory: Categories?
    @Published var categories: [Categories] = [
    ]
    
    @Published var deadLineActivate: Bool = false {
        didSet {
            if deadLineActivate {
                deadLine = tomorrow
            } else {
                deadLine = nil
            }
        }
    }
    init(fileCache: FileCache, item: ToDoItem? = nil) {
        self.fileCache = fileCache
        self.changedItem = item
        self.categories = [Categories(name: "Работа", color: Color.red),
                           Categories(name: "Учеба", color: Color.blue),
                           Categories(name: "Хобби", color: Color.green),
                           Categories(name: "Другое", color: Color.clear)]
        if let item = item {
            self.taskName = item.text
            self.selectedIcon = getIcon(from: item.priority)
            self.deadLine = item.deadLine
            self.deadLineActivate = item.deadLine != nil
            self.changedAt = Date()
            self.pickedColor = item.pickedColor ?? .clear
            self.selectedCategory = item.category
        }
    }
    
    func addItem() {
        let priority = updatePriority(from: selectedIcon)
        if !colorPickerActivate {
            pickedColor = nil
        }
        if let changedItem = changedItem {
            let item = ToDoItem(
                id: changedItem.id,
                text: taskName,
                priority: priority,
                deadLine: deadLine,
                createdAt: changedItem.createdAt,
                changedAt: Date(),
                pickedColor: pickedColor,
                category: selectedCategory
            )
            fileCache.addItem(item)
        } else {
            let item = ToDoItem(text: taskName, priority: priority, deadLine: deadLine, pickedColor: pickedColor, category: selectedCategory)
            fileCache.addItem(item)
        }
    }
    
    func deleteButtonTapped() {
        taskName = ""
        selectedIcon = .text("нет")
        deadLineActivate = false
        pickedColor = .clear
    }
    
    func showDatePicker(_ isActivate: Bool) {
        if isActivate {
            datePickerIsShown = true
        }
    }
    
    func addCategory(category: Categories) {
        categories.insert(category, at: categories.count - 1)
    }
    
    private func updatePriority(from icon: SwitchcerViewElementEnum) -> Priority {
        switch icon {
        case .text("нет"):
            return .basic
        case .text("‼️"):
            return .high
        case .image("arrow.down"):
            return .low
        default:
            return .basic
        }
    }
    
    private func getIcon(from priority: Priority) -> SwitchcerViewElementEnum {
        switch priority {
        case .basic:
            return .text("нет")
        case .high:
            return .text("‼️")
        case .low:
            return .image("arrow.down")
        }
    }
}
