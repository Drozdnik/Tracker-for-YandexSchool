import Foundation
import FileCache
class NetworkManager {
    enum CodeResult<String> {
        case success
        case failure(String)
    }

    static let enviroment: BaseURLConfig = .dev
    private let router = Router<ToDoItemApi>()
    private(set) var revision: Int?
    
    func getToDoList(completion: @escaping (_ items: [ToDoItem]?, _ error: String?) -> ()) async {
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
                    completion(apiResponse.list, nil)
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> CodeResult<String>{
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
