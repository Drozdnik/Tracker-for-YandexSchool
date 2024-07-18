import Foundation
import FileCache

struct ToDoItemResponse: Decodable {
    let status: String
    let element: ToDoItem
    let revision: Int
}
