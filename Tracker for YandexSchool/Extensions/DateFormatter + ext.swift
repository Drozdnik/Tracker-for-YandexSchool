import Foundation

extension DateFormatter {
    static let dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")  
        return formatter
    }()
}
