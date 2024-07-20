import Foundation
import FileCache

struct ToDoItemResponse: Decodable {
    let status: String
    let list: [ToDoItem]
    let revision: Int
}
