import XCTest
@testable import Tracker_for_YandexSchool

class RouterTests: XCTestCase {

    func testGetListRequest() throws {
        // Given
        let router = Router<ToDoItemApi>()
        
        // When
        let request = try router.buildRequest(from: .getList)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "https://hive.mrdekk.ru/todo/list")
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Irime")
    }
}
