import Foundation
import SwiftUI
import UIKit

@available(iOS 17, *)
extension ToDoItem: Sendable {
    
    public var jsonData: [String:Any] {
        let isoFormatter = ISO8601DateFormatter.shared
        isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        var jsonObject: [String: Any] = [
            "id": id.uuidString,
            "text": text,
            "done": flag,
            "created_at": Int(createdAt.timeIntervalSince1970),
            "importance": priority.rawValue
        ]
        
        
        if let deadLine = deadLine {
            jsonObject["deadline"] = Int(deadLine.timeIntervalSince1970)
        }
        
        if let changedAt = changedAt {
            jsonObject["changed_at"] = Int(changedAt.timeIntervalSince1970)
        } else {
            jsonObject["changed_at"] = Int(createdAt.timeIntervalSince1970)
        }
        
        if let colorString = pickedColor?.toHexString() {
            jsonObject["color"] = colorString
        }
        
        jsonObject["last_updated_by"] = "2DB30CFC-F536-43E2-A826-A5D5D5EFA4F1"
        
        let wrappedObject = ["element": jsonObject]
        
        return wrappedObject
    }
    
    
    public static func parse(json: Any) -> ToDoItem? {
        let isoFormatter = ISO8601DateFormatter.shared
        
        guard let jsonAsData = json as? Data else {
            assertionFailure("\(JSONErrorEnum.jsonAsDataError)")
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
            priority = .basic
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
    
    public static func parseCSV(csvString: String) -> [ToDoItem] {
        let isoFormatter = ISO8601DateFormatter.shared
        
        var items: [ToDoItem] = []
        let rows = csvString.split(separator: "\n")
        
        for row in rows.dropFirst() {
            let columns = parseCSVRow(String(row))
            guard columns.count >= 7 else {continue}
            let id = UUID(uuidString: columns[0])
            let text = columns[1]
            let priority = Priority(rawValue: columns[2]) ?? .basic
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
    
    public static func parseCSVRow(_ row: String) -> [String] {
        var columns = [String]()
        let pattern = #" *"(?:[^"\\]*(?:\\.[^"\\]*)*)"|[^,]+"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: row, options: [], range: NSRange(location: 0, length: row.utf16.count))
            
            for match in matches {
                if let columnRange = Range(match.range, in: row) {
                    var column = String(row[columnRange])
                    column = column.trimmingCharacters(in: .whitespacesAndNewlines)
                    if column.first == "\"" && column.last == "\"" {
                        column = String(column.dropFirst().dropLast())
                        column = column.replacingOccurrences(of: "\\\"", with: "\"")
                    }
                    columns.append(column)
                }
            }
        } catch {
            print("Failed to create regular expression: \(error)")
        }
        return columns
    }
}
//Почему то не хотелось тянуться из другого файла
extension Color {
    public func toHexString() -> String {
        if #available(iOS 14.0, *) {
            guard let components = UIColor(self).cgColor.components else {
                return "#000000"
            }
            let red: CGFloat
            let green: CGFloat
            let blue: CGFloat
            
            if components.count >= 3 {
                red = components[0]
                green = components[1]
                blue = components[2]
            } else {
                red = components[0]
                green = components[0]
                blue = components[0]
            }
            
            return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        } else {
            return" #000000"
        }
    }
}

