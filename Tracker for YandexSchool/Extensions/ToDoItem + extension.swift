//
//  ToDoItem + extension.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import Foundation

extension ToDoItem: ToDoItemParseProtocol {
    
    var json: Any {
        let isoFormatter = ISO8601DateFormatter.shared
        var jsonObject: [String: Any] = [
            "id": id,
            "text": text,
            "flag": flag,
            "createdAt": isoFormatter.string(from: createdAt)
        ]
        
        if priority != .normal{
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
    
    static func parse(json: Any) -> ToDoItem?{
        let isoFormatter = ISO8601DateFormatter.shared
        guard let jsonAsData = json as? Data else {
            assertionFailure ("\(JSONErrorEnum.jsonAsDataError)")
            return nil
        }
        guard let jsonData = try? JSONSerialization.jsonObject(with: jsonAsData) as? [String : Any] else {
            return nil
        }
        
        guard let id = jsonData["id"] as? String,
              let text = jsonData["text"] as? String,
              let flag = jsonData["flag"] as? Bool,
              let createdAtString = jsonData["createdAt"] as? String else {
            return nil
        }
        
        guard let createdAt = isoFormatter.date(from: createdAtString) else {
            print ("\(createdAtString)")
            return nil
        }
        
        var changedAt: Date? = nil
        if let changedAtTimeString = jsonData["changedAt"] as? String {
            changedAt = isoFormatter.date(from: changedAtTimeString)
        }
        
        var deadLine: Date? = nil
        if let deadLineString = jsonData["deadLine"] as? String{
            deadLine = isoFormatter.date(from: deadLineString)
        }
        
        let priority: Priority
        if let priorityRaw = jsonData["priority"] as? String,
           let value = Priority(rawValue: priorityRaw){
            priority = value
        } else {
            priority = Priority.normal
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
    // В CSV файле пустые данные заполнены как nil
    static func parseCSV(csvString: String) -> [ToDoItem]{
        let isoFormatter = ISO8601DateFormatter.shared
        
        var items: [ToDoItem] = []
        let rows = csvString.split(separator: "\n")
        
        for row in rows.dropFirst(){
            let columns = row.split(separator: ",").map({String($0)})
            let id = columns[0]
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
                                createdAt: createdAt!,
                                changedAt: changedAt)
            items.append(item)
        }
        return items
        
    }
}



