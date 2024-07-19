import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) async {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: router)
            logRequest(request)
            let (data, response) = try await session.dataTask(for: request)
            completion(data, response, nil)
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
   func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        // Todo: find betterPlace to token
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer Irime", forHTTPHeaderField: "Authorization")
                self.addAditionalHeaders(nil, request: &request)
                
            case .requestWithBody(
                let bodyParameters,
                let additionalHeaders
            ):
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer Irime", forHTTPHeaderField: "Authorization")
                    try self.configureParameters(parameter: bodyParameters, request: &request)
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
        parameter: Parameters,
        request: inout URLRequest
    ) throws {
        do {
            try JSONParameterEncoder.encode(urlRequest: &request, parameters: parameter)
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
    
    private func logRequest(_ request: URLRequest) {
        print("\n------------------\n")
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("HTTP Method: \(request.httpMethod ?? "No HTTP Method")")
        
        print("Headers: ")
        if let headers = request.allHTTPHeaderFields {
            for (header, value) in headers {
                print("\(header): \(value)")
            }
        } else {
            print("No headers")
        }
        
        print("Body: ")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print(bodyString)
        } else {
            print("No body")
        }
        print("\n------------------\n")
    }
}
