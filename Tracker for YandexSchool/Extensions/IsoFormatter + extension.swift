//
//  IsoFormatter + extension.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 17.06.2024.
//

import Foundation

extension ISO8601DateFormatter{
    static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
