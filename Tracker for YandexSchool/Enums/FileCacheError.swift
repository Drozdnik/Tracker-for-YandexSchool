//
//  FileCacheError.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 18.06.2024.
//

import Foundation

enum FileCacheError: Error{
    case itemNotFound
    case savingError
    case urlCreationError
    case loadingError
}
