import XCTest
@testable import Tracker_for_YandexSchool

final class Tracker_for_YandexSchoolTests: XCTestCase {

    func testInit(){
        let item = ToDoItem(text: "Тест", priority: .low)
        XCTAssertNotNil(item.id)
        XCTAssertEqual(item.text, "Тест")
        XCTAssertEqual(item.priority, .low)
        XCTAssertFalse(item.flag)
        XCTAssertNil(item.deadLine)
        XCTAssertNotNil(item.createdAt)
        XCTAssertNil(item.changedAt)
    }
    
    func testJSONSerialization() {

            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let item = ToDoItem(id: UUID(uuidString: "123") , text: "Complete the task", priority: .high, flag: true)

        let jsonResult = item.json
            
            XCTAssert(jsonResult is Data)
            
            if let data = jsonResult as? Data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                XCTAssertEqual(jsonObject["id"] as? UUID, UUID(uuidString: "123"))
                XCTAssertEqual(jsonObject["text"] as? String, "Complete the task")
                XCTAssertEqual(jsonObject["priority"] as? String, "важная")
                XCTAssertEqual(jsonObject["flag"] as? Bool, true)
            } else {
                XCTFail("bad JSON")
            }
        }
    
    func testJSONToToDoItem(){
        let json = """
        {
    "id": "09c43515-6dfe-4cf9-9682-77c9751cc8d6",
        "text": "test",
        "priority": null,
        "flag": false,
        "deadLine": "2024-06-25T20:22:32Z",
        "createdAt": "2024-06-18T20:22:32Z",
        "changedAt": "2024-06-19T20:22:32Z"
    }
""".data(using: .utf8)!
        guard let item = ToDoItem.parse(json: json) else {
            XCTFail("Fail to parse JSON")
            return 
        }
        
        XCTAssertEqual(item.id, UUID(uuidString: "09c43515-6dfe-4cf9-9682-77c9751cc8d6"))
        XCTAssertEqual(item.text, "test")
        XCTAssertEqual(item.priority.rawValue, "обычная")
        XCTAssertEqual(item.changedAt, ISO8601DateFormatter.shared.date(from: "2024-06-19T20:22:32Z"))
    }
    
    func testToDoToJSONToToDo(){
        let item = ToDoItem(id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"), text: "Complete the task", priority: .high, flag: true)

        let jsonResult = item.json
        
        guard let item = ToDoItem.parse(json: jsonResult) else {
            XCTFail("Failed to parse")
            return
        }
        
        XCTAssertEqual(item.id, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertEqual(item.text, "Complete the task")
        XCTAssertEqual(item.priority.rawValue, "важная")
        XCTAssertEqual(item.flag, true)
        XCTAssertNotNil(item.createdAt)
    }
    
    func testParseCsv(){
        let csvString = """
                id,text,priority,flag,createdAt,deadLine,changedAt
                09c43515-6dfe-4cf9-9682-77c9751cc8d6, "Тест, с запятой",nil,false,2024-06-18T20:22:32Z,2024-06-25T20:22:32Z,2024-06-19T20:22:32Z
                """
        let item = ToDoItem.parseCSV(csvString: csvString)
        
        XCTAssertEqual(item[0].id, UUID(uuidString: "09c43515-6dfe-4cf9-9682-77c9751cc8d6"))
        XCTAssertEqual(item[0].text, "Тест, с запятой")
        XCTAssertEqual(item[0].priority.rawValue, "обычная")
        XCTAssertEqual(item[0].changedAt, ISO8601DateFormatter.shared.date(from: "2024-06-19T20:22:32Z"))
    }
}
