import Foundation

extension DateFormatter {
    static let dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = DeviceUtils.getPreferredLocale()
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")
        return formatter
    }()
    
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = DeviceUtils.getPreferredLocale()
        formatter.setLocalizedDateFormatFromTemplate("dMMMMYYYY")
        return formatter
    }()
}

