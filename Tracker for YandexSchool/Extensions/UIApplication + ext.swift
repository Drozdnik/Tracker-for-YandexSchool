//
//  UIApplication + ext.swift
//  Tracker for YandexSchool
//
//  Created by Михаил  on 23.06.2024.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
