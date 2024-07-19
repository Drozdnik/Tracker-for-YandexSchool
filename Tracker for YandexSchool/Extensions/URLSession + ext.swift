import Foundation
// Для предотвращения data race дополнительно обернул это в actor
extension URLSession {
    func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        let networkActor = NetworkServiceActor()
        print(request)
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let dataTask = self.dataTask(with: request) { data, response, error in
                    if let error = error {
                        handleNetworkError(NetworkError.continuationError(error))
                        continuation.resume(throwing: NetworkError.continuationError(error))
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let noDataError = NetworkError.noDataInRespone
                        handleNetworkError(noDataError)
                        continuation.resume(throwing: noDataError)
                    }
                }

                Task {
                    await networkActor.set(dataTask)

                    if await networkActor.isCancelled {
                        let canceledError = NetworkError.taskCanceled
                        handleNetworkError(canceledError)
                        continuation.resume(throwing: canceledError)
                    } else {
                        dataTask.resume()
                    }
                }
            }
        } onCancel: {
            Task {
                await networkActor.cancel()
            }
        }
    }
}
