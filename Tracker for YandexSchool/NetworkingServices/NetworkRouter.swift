import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter {
    associatedtype EndPoint: EndPointType
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) async
    func cancel()
}
