//
//  ToDoItem.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 16.06.2024.
//

import Foundation

struct ToDoItem{
    let id: String
    let text: String
    let importance: Importance
    
}


enum Importance: String{
    case low = "неважная"
    case medium = "обычная"
    case high = "важная"
}
