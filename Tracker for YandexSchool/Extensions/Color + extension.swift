import SwiftUI

extension Color {
    static let backgroundColor = Color("backgroundColor")

    func toHexString() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
