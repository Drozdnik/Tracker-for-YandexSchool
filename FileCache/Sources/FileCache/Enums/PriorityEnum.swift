import Foundation

public enum Priority: String, Comparable, Decodable {
    case low = "low"
    case basic = "basic"
    case high = "important"

    public static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.order < rhs.order
    }
    
    public var order: Int {
        switch self {
        case .high: return 3
        case .basic: return 2
        case .low: return 1
        }
    }
}
