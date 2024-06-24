import Foundation


enum Priority: String, Comparable {
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.order < rhs.order
    }
    
    case low = "неважная"
    case normal = "обычная"
    case high = "важная"
    
    private var order: Int {
        switch self {
        case .high: return 3
        case .normal: return 2
        case .low: return 1
        }
    }
}


