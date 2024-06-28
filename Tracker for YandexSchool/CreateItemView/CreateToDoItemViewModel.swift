import SwiftUI

final class CreateToDoItemViewModel: ObservableObject {
    private let fileCache: FileCache
    private var changedItem: ToDoItem?
    private var changedAt: Date?
    private let tomorrow: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    @Published var taskName: String = ""
    @Published var selectedIcon: SwitchcerViewElementEnum = .text("нет")
    @Published var deadLine: Date? = nil
    @Published var datePickerIsShown: Bool = false
    @Published var pickedColor: Color? = nil
    @Published var colorPickerIsShown: Bool = false
    @Published var colorPickerActivate: Bool = false
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
        
        if let item = item {
            self.taskName = item.text
            self.selectedIcon = getIcon(from: item.priority)
            self.deadLine = item.deadLine
            self.deadLineActivate = item.deadLine != nil
            self.changedAt = Date()
            self.pickedColor = item.pickedColor ?? .clear
        }
    }
    
    func addItem() {
        let priority = updatePriority(from: selectedIcon)
        if let changedItem = changedItem {
            let item = ToDoItem(
                id: changedItem.id,
                text: taskName,
                priority: priority,
                deadLine: deadLine,
                createdAt: changedItem.createdAt,
                changedAt: Date(),
                pickedColor: pickedColor
            )
            fileCache.addItem(item)
        } else {
            let item = ToDoItem(text: taskName, priority: priority, deadLine: deadLine, pickedColor: pickedColor)
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
        if isActivate{
            datePickerIsShown = true
        }
    }
    
    private func updatePriority(from icon: SwitchcerViewElementEnum) -> Priority {
        switch icon {
        case .text("нет"):
            return .normal
        case .text("‼️"):
            return .high
        case .image("arrow.down"):
            return .low
        default:
            return .normal
        }
    }
    
    private func getIcon(from priority: Priority) -> SwitchcerViewElementEnum {
        switch priority {
        case .normal:
            return .text("нет")
        case .high:
            return .text("‼️")
        case .low:
            return .image("arrow.down")
        }
    }
}

