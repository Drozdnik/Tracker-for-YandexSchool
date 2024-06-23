import SwiftUI

final class DiContainer: ObservableObject{
    let fileCache = FileCacheImpl(fileName: "ToDoItem.json")
}


