import SwiftUI
import FileCache

final class DiContainer: ObservableObject {
    let fileCache = FileCacheImpl(fileName: "ToDoItem.json")
}
