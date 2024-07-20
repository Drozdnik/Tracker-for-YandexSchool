import Foundation

enum ParameterErrorEnum: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFails = "Parameters encoding fails"
    case missingURL = "URL was nil"
}

struct URLParametrEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw ParameterErrorEnum.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        }
    }
}
