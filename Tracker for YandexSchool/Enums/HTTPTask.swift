import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

enum HTTPTask {
    case request
    case requestWithBody (
        bodyParameters: Parameters,
        additionalHeaders: HTTPHeaders
    )
    case requestHeaders(additionalHeaders: HTTPHeaders)
}
