import Foundation

public enum FileCacheError: Error {
    case itemNotFound
    case savingError
    case urlCreationError
    case loadingError
    case deleteError
}
