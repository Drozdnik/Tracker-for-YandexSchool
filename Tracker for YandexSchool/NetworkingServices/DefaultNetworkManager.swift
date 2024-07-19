import Foundation
import FileCache

protocol NetworkManager {
    var revision: Int? { get set }
    func getToDoList(completion: @escaping (_ items: [ToDoItem]?, _ error: String?) -> Void) async
    func addToDoItem(_ item: ToDoItem, completion: @escaping (_ error: String?) -> Void) async
}

class DefaultNetworkManager: NetworkManager {
    enum CodeResult<String> {
        case success
        case failure(String)
    }

    static let enviroment: BaseURLConfig = .dev
    private let router = Router<ToDoItemApi>()
    var revision: Int?
    
    func getToDoList(completion: @escaping (_ items: [ToDoItem]?, _ error: String?) -> Void) async {
        await router.request(.getList) { [weak self] data, response, error in
            guard let self else { return }
            if error != nil {
                completion(nil, "Please check your network connection.")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, "Invalid response.")
                return
            }
            
            switch self.handleNetworkResponse(response) {
            case .success:
                guard let responseData = data else {
                    completion(nil, NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let apiResponse = try decoder.decode(ToDoItemResponse.self, from: responseData)
                    self.revision = apiResponse.revision
                    print(self.revision)
                    completion(apiResponse.list, nil)
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    func addToDoItem(_ item: ToDoItem, completion: @escaping (_ error: String?) -> Void
    ) async {
            guard let revision = self.revision else {
                completion(NetworkResponse.badRevision.rawValue)
                return
            }
        await router.request(.addElement(item, revision: revision, id: item.id)) { [weak self] data, response, error in
                guard let self = self else { return }

                if error != nil {
                    completion(NetworkResponse.badInternet.rawValue)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(NetworkResponse.badRequest.rawValue)
                    return
                }
                
                switch self.handleNetworkResponse(response) {
                case .success:
                    guard let reponseData = data else {
                        completion(NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let apiResponce = try decoder.decode(ToDoItemResponse.self, from: reponseData)
                        self.revision = apiResponce.revision
                    } catch {
                        completion(NetworkResponse.unableToDecode.rawValue)
                    }
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
        }
    
    func patchItems(completion: @escaping (_ items: [ToDoItem]?, _ error: String?) -> Void) async {
        guard let revision = self.revision else {
            completion(nil, NetworkResponse.badInternet.rawValue)
            return
        }
        await router.request(.upgradeOnServer(revision: revision)) { data, response, error in
            if error != nil {
                completion([],NetworkResponse.badInternet.rawValue)
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkResponse.badRequest.rawValue)
                return
            }
            switch self.handleNetworkResponse(response) {
            case .success:
                guard let reponseData = data else {
                    completion(nil, NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let apiResponce = try decoder.decode(ToDoItemResponse.self, from: reponseData)
                    self.revision = apiResponce.revision
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
//                completion(nil, nil)
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    func getElementById(id: UUID, completion: @escaping (_ item: ToDoItem?, _ error: String?) -> Void) async {
        guard let revision = self.revision else {
            completion(nil, NetworkResponse.badInternet.rawValue)
            return
        }
        await router.request(.getElement(id: id)) { data, response, error in
            if error != nil {
                completion(nil, NetworkResponse.badInternet.rawValue)
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkResponse.badRequest.rawValue)
                return
            }
            switch self.handleNetworkResponse(response) {
            case .success:
                guard let reponseData = data else {
                    completion(nil, NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let apiResponce = try decoder.decode(ToDoItemResponse.self, from: reponseData)
                    self.revision = apiResponce.revision
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
//                completion(nil, nil)
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> CodeResult<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401: return .failure(NetworkResponse.authenticationError.rawValue)
        case 400: return .failure(NetworkResponse.badRevision.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}
