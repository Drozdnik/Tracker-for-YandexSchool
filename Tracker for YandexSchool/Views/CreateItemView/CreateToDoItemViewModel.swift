import SwiftUI
import FileCache
import CocoaLumberjackSwift

final class CreateToDoItemViewModel: ObservableObject {
    private let networkManager: NetworkManager
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
    init(fileCache: FileCache, item: ToDoItem? = nil, networkManager: NetworkManager) {
        self.fileCache = fileCache
        self.networkManager = networkManager
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
            Task {
                await changeItemNetwork(item: item, id:item.id)
            }
           try? fileCache.addItem(item)
        } else {
            let item = ToDoItem(text: taskName, priority: priority, deadLine: deadLine, pickedColor: pickedColor, category: selectedCategory)
            Task {
                await addItemNetwork(item: item)
            }
           try? fileCache.addItem(item)
        }
    }
    
    func deleteButtonTapped(){
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
    
    private func addItemNetwork(item: ToDoItem) {
        Task {
            networkManager.synchronizeIfNeeded { [weak self] synchronizedItems in
                guard let self = self else { return }
                if let synchronizedItems {
                    for item in synchronizedItems {
                      try? self.fileCache.addItem(item)
                    }
                    self.performAddItemNetwork(item: item)
                } else {
                    self.performAddItemNetwork(item: item)
                }
            }
        }
    }

    private func performAddItemNetwork(item: ToDoItem) {
        Task {
            await networkManager.networkRequest(
                with: .addElement(
                    item,
                    revision: networkManager.revision,
                    id: item.id
                )
            ) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        DDLogInfo("Successfully added item with id: \(item.id)")
                    case .failure(let error):
                        DDLogWarn("Failed to add item with id: \(item.id) with \(error)")
                    }
                }
            }
        }
    }

    private func changeItemNetwork(item: ToDoItem, id: UUID) {
        Task {
            networkManager.synchronizeIfNeeded { [weak self] synchronizedItems in
                guard let self = self else { return }
                if let synchronizedItems {
                    for item in synchronizedItems {
                       try? self.fileCache.addItem(item)
                    }
                    self.performChangeItemNetwork(item: item, id: id)
                } else {
                    self.performChangeItemNetwork(item: item, id: id)
                }
            }
        }
    }

    private func performChangeItemNetwork(item: ToDoItem, id: UUID) {
        Task {
            await networkManager.networkRequest(
                with: .changeElement(item: item, id: id, revision: networkManager.revision)
            ) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        DDLogInfo("Successfully changed item with id: \(id)")
                    case .failure(let error):
                        DDLogWarn("Failed to change item with id: \(id) with \(error)")
                    }
                }
            }
        }
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
