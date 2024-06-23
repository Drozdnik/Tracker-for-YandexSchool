import SwiftUI

final class CreateToDoItemViewModel: ObservableObject {
    private let fileCache: FileCache
    
    @Published var taskName: String = ""
    @Published var selectedIcon: SwitchcerViewElementEnum = .text("нет")
    @Published var deadLine: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    @Published var deadLineActivate: Bool = false
    @Published var datePickerIsShown: Bool = false 
    
    init(fileCache: FileCache){
        self.fileCache = fileCache
    }
    
    func addItem() {
        let priority = updatePriority(from: selectedIcon)
        
        let item = ToDoItem(text: taskName, priority: priority, deadLine: deadLine)
        fileCache.addItem(item)
    }
    
    func deleteButtonTapped() {
        taskName = ""
        selectedIcon = .text("нет")
        deadLineActivate = false
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
}

