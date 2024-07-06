import Foundation

extension ToDoItem: ToDoItemParseProtocol {
    
    var json: Any {
        let isoFormatter = ISO8601DateFormatter.shared
        var jsonObject: [String: Any] = [
            "id": id.uuidString,
            "text": text,
            "flag": flag,
            "createdAt": isoFormatter.string(from: createdAt)
        ]
        
        if priority != .normal {
            jsonObject["priority"] = priority.rawValue
        }
        
        if let deadLine = deadLine {
            jsonObject["deadLine"] = isoFormatter.string(from: deadLine)
        }
        
        if let changedAt = changedAt {
            jsonObject["changedAt"] = isoFormatter.string(from: changedAt)
        }
        
        if let json = try? JSONSerialization.data(withJSONObject: jsonObject){
            return json
        } else {
            return JSONErrorEnum.createJSONError
        }
    }
    
    static func parse(json: Any) -> ToDoItem? {
        let isoFormatter = ISO8601DateFormatter.shared
        
        
        guard let jsonAsData = json as? Data else {
                   assertionFailure ("\(JSONErrorEnum.jsonAsDataError)")
                   return nil
               }
               guard let jsonData = try? JSONSerialization.jsonObject(with: jsonAsData) as? [String : Any] else {
                   return nil
               }
        
        guard let idString = jsonData["id"] as? String,
              let id = UUID(uuidString: idString),
              let text = jsonData["text"] as? String,
              let flag = jsonData["flag"] as? Bool,
              let createdAtString = jsonData["createdAt"] as? String,
              let createdAt = isoFormatter.date(from: createdAtString) else {
            return nil
        }

        let changedAt: Date? = (jsonData["changedAt"] as? String).flatMap(isoFormatter.date(from:))
        let deadLine: Date? = (jsonData["deadLine"] as? String).flatMap(isoFormatter.date(from:))

        let priority: Priority
        if let priorityRaw = jsonData["priority"] as? String,
           let value = Priority(rawValue: priorityRaw) {
            priority = value
        } else {
            priority = .normal
        }

        return ToDoItem(
            id: id,
            text: text,
            priority: priority,
            deadLine: deadLine,
            flag: flag,
            createdAt: createdAt,
            changedAt: changedAt
        )
    }

    static func parseCSV(csvString: String) -> [ToDoItem] {
        let isoFormatter = ISO8601DateFormatter.shared
        
        var items: [ToDoItem] = []
        let rows = csvString.split(separator: "\n")
        
        for row in rows.dropFirst(){
            let columns = parseCSVRow(String(row))
            guard columns.count >= 7 else {continue}
            let id = UUID(uuidString: columns[0])
            let text = columns[1]
            let priority = Priority(rawValue: columns[2]) ?? .normal
            let flag = columns[3] == "true"
            let createdAt = columns[4] != "nil" ? isoFormatter.date(from: columns[4]) : Date()
            let deadLine = columns[5] != "nil" ? isoFormatter.date(from: columns[5]) : nil
            let changedAt = columns[6] != "nil" ? isoFormatter.date(from: columns[6]) : nil
            
            let item = ToDoItem(id: id,
                                text: text,
                                priority: priority,
                                deadLine: deadLine,
                                flag: flag,
                                createdAt: createdAt ?? Date(),
                                changedAt: changedAt)
            items.append(item)
        }
        return items
    }
    
    static func parseCSVRow(_ row: String) -> [String] {
        var columns = [String]()
        let pattern = #" *"(?:[^"\\]*(?:\\.[^"\\]*)*)"|[^,]+"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: row, options: [], range: NSRange(location: 0, length: row.utf16.count))
        
        for match in matches {
            let columnRange = Range(match.range, in: row)!
            var column = String(row[columnRange])
            column = column.trimmingCharacters(in: .whitespacesAndNewlines)
            if column.first == "\"" && column.last == "\"" {
                column = String(column.dropFirst().dropLast())
                column = column.replacingOccurrences(of: "\\\"", with: "\"")
            }
            columns.append(column)
        }
        return columns
    }
}
