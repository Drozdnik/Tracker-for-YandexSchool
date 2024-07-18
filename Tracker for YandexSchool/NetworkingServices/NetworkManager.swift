import Foundation

struct NetworkManager {
    static let enviroment: BaseURLConfig = .dev
    static let BearerToken = "Token"
    private let router = Router<ToDoItemApi>()
}
