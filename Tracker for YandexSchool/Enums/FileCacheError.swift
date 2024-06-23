import Foundation

enum FileCacheError: Error{
    case itemNotFound
    case savingError
    case urlCreationError
    case loadingError
}
