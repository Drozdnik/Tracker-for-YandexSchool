import Foundation

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws 
}
