import Foundation

enum NetworkResponse: String, Error {
    case success
    case authenticationError = "No Auth."
    case badRevision = "Bad Revision"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case badInternet = "Bad internet"
    case failedError = "Case failure"
}
