import Foundation
import FileCache

struct ToDoListResponse: Decodable {
    let status: String
    let list: [ToDoItem]
    let revision: Int
}

struct ToDoItemResponse: Decodable {
    let status: String
    let element: ToDoItem
    let revision: Int
}
