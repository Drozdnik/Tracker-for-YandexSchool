import Foundation
import FileCache

struct  ToDoItemResponce: Decodable {
    let status: String
    let list: [ToDoItem]
    let revision: Int
}

