import Foundation
// Для предотвращения data race дополнительно обернул это в actor
extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: NetworkError.continuationError(error))
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: NetworkError.noDataInRespone)
                }
            }
            
            task.resume()
            
            Task {
                await withTaskCancellationHandler {
                } onCancel: {
                    task.cancel()
                    continuation.resume(throwing: NetworkError.taskCanceled)
                }
            }
        }
    }
}
