import XCTest
@testable import Tracker_for_YandexSchool

final class NetworkTests: XCTestCase {
    
    func testFetchPosts() async throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            XCTFail("URL is invalid")
            return
        }
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.dataTask(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                XCTFail("Failed to fetch posts, HTTP status code is not 200")
                return
            }
            XCTAssertFalse(data.isEmpty, "No data was downloaded.")
        } catch {
            XCTFail("Test failed with error: \(error)")
        }
    }
    
    func testCancellation() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            XCTFail("URL is invalid")
            return
        }
        let request = URLRequest(url: url)
        
        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: request)
                XCTFail("Not cancelled")
            } catch {
                if let error = error as? NetworkError, case .taskCanceled = error {
                    DDLogInfo("Task was successfully cancelled.")
                } else {
                    XCTFail("Task failed for an unexpected reason: \(error)")
                }
            }
        }
        
        task.cancel()
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            XCTFail("Cancellation failed")
        }
    }
}
