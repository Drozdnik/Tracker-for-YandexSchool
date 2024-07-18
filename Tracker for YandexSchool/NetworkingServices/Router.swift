import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) async {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: router)
            let (data, response) = try await session.dataTask(for: request)
            completion(data, response, nil)
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                self.addAditionalHeaders(nil, request: &request)
                
            case .requestWithBody(
                let bodyParameters,
                let additionalHeaders
            ):
                try self.configureParameters(bodyParameters: bodyParameters, request: &request)
                self.addAditionalHeaders(additionalHeaders, request: &request)
            case .requestHeaders(let headers):
                self.addAditionalHeaders(headers, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(
        bodyParameters: Parameters?,
        request: inout URLRequest
    ) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, parameters: bodyParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func addAditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
