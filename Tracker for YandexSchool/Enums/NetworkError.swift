import Foundation
import CocoaLumberjackSwift

enum NetworkError: Error {
    case noDataInRespone
    case continuationError(Error) // toChange
    case taskCanceled
}

func handleNetworkError(_ error: NetworkError){
    switch error {
    case .continuationError(let networkError):
        DDLogWarn("Ошибка в сетевом запросе \(networkError)")
    case .noDataInRespone:
        DDLogWarn("Запрос без даты")
    case .taskCanceled:
        DDLogInfo("Запрос был отменен")
    }
}
