import Foundation
import FileCache

enum ToDoItemApi {
    case getList
    case upgradeOnServer(revision: Int)
    case getElement(id: UUID)
    case addElement(ToDoItem, revision: Int)
    case changeElement(id: UUID, revision: Int)
    case deleteElement(id: UUID, revision: Int)
}

enum BaseURLConfig {
    case dev
}



extension ToDoItemApi: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.enviroment {
        case .dev:
            return "https://hive.mrdekk.ru/todo"
        }
    }
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getList, .upgradeOnServer:
            return "/list"
        case .getElement(let id), .changeElement(let id, _), .deleteElement(let id, _):
            return "/list/\(id)"
        case .addElement:
            return "/list"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getList, .getElement, .upgradeOnServer:
            return .get
        case .addElement:
            return .post
        case .changeElement:
            return .put
        case .deleteElement:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getList, .getElement, .deleteElement, .changeElement:
            return .request
        case .upgradeOnServer(let revision), .addElement(_, let revision):
            return .requestHeaders(additionalHeaders: ["X-Last-Known-Revision": "\(revision)"])
        }
    }
    
//    var headers: HTTPHeaders? {
//        let bearerToken = "Irime"
//        
//        var headers = HTTPHeaders()
//        headers["Authorization"] = bearerToken
//        return headers
//    }
    
    
}
