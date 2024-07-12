import Foundation

enum NetworkError: Error {
    case noDataInRespone
    case continuationError(Error) // toChange
    case taskCanceled
}
