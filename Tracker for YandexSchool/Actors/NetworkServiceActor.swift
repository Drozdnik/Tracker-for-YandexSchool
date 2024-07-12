import Foundation

actor NetworkServiceActor {
    private let session = URLSession.shared
    
    func dataTask(for URLRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: URLRequest)
    }
}
