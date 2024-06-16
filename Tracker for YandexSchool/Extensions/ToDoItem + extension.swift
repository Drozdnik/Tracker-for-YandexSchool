//
//  ToDoItem + extension.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import Foundation

extension ToDoItem {
    var json: Any {
        var jsonObject: [String: Any] = [
            "id": id,
            "text": text,
            "flag": flag,
            "createdAt": createdAt
        ]
        if priority != .normal{
            jsonObject["priority"] = priority.rawValue
        }
        
        if let deadLine = deadLine {
            jsonObject["deadLine"] = deadLine
        }
        
        if let changedAt = changedAt {
            jsonObject["changedAt"] = changedAt
        }
        
        return jsonObject
    }
    
    static func parse(json: Any) -> ToDoItem?{
        guard let jsonData = json as? [String: Any] else {
            return nil
        }
        
        guard let id = jsonData["id"] as? String,
              let text = jsonData["text"] as? String,
              //              let priority = jsonData["priority"] as? String,
              let flag = jsonData["flag"] as? Bool,
              let createdAt = jsonData["createdAt"] as? Date else {
            return nil
        }
        
        let changedAt: Date?
        if let changedAtTime = jsonData["changedAt"] as? Date{
            changedAt = changedAtTime
        } else{
            changedAt = nil
        }
        
        let deadLine: Date?
        if let deadLineTime = jsonData["deadLine"] as? Date{
            deadLine = deadLineTime
        } else {
            deadLine = nil
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
}
    
