import Foundation
import FileCache

enum ToDoItemApi {
    case getList
    case upgradeOnServer(revision: Int)
    case getElement(id: UUID)
    case addElement(ToDoItem, revision: Int, id: UUID)
    case changeElement(item: ToDoItem, id: UUID, revision: Int)
    case deleteElement(id: UUID, revision: Int)
}

enum BaseURLConfig {
    case dev
}

extension ToDoItemApi: EndPointType {
    
    var environmentBaseURL: String {
        switch DefaultNetworkManager.enviroment {
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
        case .getElement(let id), .changeElement(_, let id, _), .deleteElement(let id, _):
            return "/list/\(id)"
        case .addElement:
            return "/list"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getList, .getElement:
            return .get
        case .changeElement:
            return .put
        case .deleteElement:
            return .delete
        case .addElement:
            return .post
        case .upgradeOnServer:
            return .patch
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getList, .getElement:
            return .request
        case .upgradeOnServer(let revision), .deleteElement(_, let revision):
            return .requestHeaders(
                additionalHeaders: ["X-Last-Known-Revision": "\(revision)",
                                    "Authorization": "Bearer Irime"
                                   ])
        case .addElement(let item, let revision, _), .changeElement( let item, _, let revision):
            return .requestWithBody(
                bodyParameters: item.jsonData,
                additionalHeaders: ["X-Last-Known-Revision": "\(revision)"]
            )
        }
    }
}
