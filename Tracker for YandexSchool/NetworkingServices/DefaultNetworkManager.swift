import Foundation
import FileCache
import CocoaLumberjackSwift

protocol NetworkManager {
    var revision: Int { get set }
    func networkRequest(with route: ToDoItemApi, completion: @escaping (Result<Any, NetworkResponse>) -> Void) async
    func synchronizeIfNeeded(completion: @escaping ([ToDoItem]?) -> Void)
    var isDirty: Bool { get set }
}

class DefaultNetworkManager: NetworkManager {
    enum CodeResult<String> {
        case success
        case failure(String)
    }
    
    static let enviroment: BaseURLConfig = .dev
    private let router = Router<ToDoItemApi>()
    var revision: Int = 0
    var isDirty: Bool = false
    
    func networkRequest(with route: ToDoItemApi, completion: @escaping (Result<Any, NetworkResponse>) -> Void) async {
        await router.request(route) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }
            
            if let error = error {
                self.isDirty = true
                completion(.failure(.badInternet))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.isDirty = true
                completion(.failure(.badRequest))
                return
            }
            
            switch self.handleNetworkResponse(httpResponse) {
            case .success:
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    switch route {
                    case .getList, .upgradeOnServer:
                        let decodedData = try decoder.decode(ToDoListResponse.self, from: data)
                        if self.revision != decodedData.revision {
                            self.revision = decodedData.revision
                        }
                        completion(.success(decodedData))
                    default:
                        let decodedData = try decoder.decode(ToDoItemResponse.self, from: data)
                        if self.revision != decodedData.revision {
                            self.revision = decodedData.revision
                        }
                        completion(.success(decodedData))
                    }
                } catch {
                    self.isDirty = true
                    completion(.failure(.unableToDecode))
                }
            case .failure(let networkResponse):
                self.isDirty = true
                completion(.failure(.unableToDecode))
            }
        }
    }
    
    
    func synchronizeIfNeeded(completion: @escaping ([ToDoItem]?) -> Void) {
        if isDirty {
            Task {
                let result = await networkRequest(with: .upgradeOnServer(revision: revision)) { syncResult in
                    switch syncResult {
                    case .success(let response):
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.isDirty = false
                            if let listResponse = response as? ToDoListResponse {
                                completion(listResponse.list)
                            } else if let itemResponse = response as? ToDoItemResponse {
                                completion([itemResponse.element])
                            } else {
                                completion(nil)
                            }
                        }
                    case .failure(let error):
                        DDLogWarn("Ошибка синхронизации: \(error)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        } else {
            completion(nil)
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
