import Foundation

enum NotificationOffset: String, CaseIterable {

    case day = "1 Day Before"
    case sixHours = "6 Hours Before"
    case hour = "1 Hour Before"
    case thirtyMinutes = "30 Minutes Before"
    case tenMinutes = "10 Minutes Before"

    var seconds: TimeInterval {
        switch self {
        case .day:
            return 86400
        case .sixHours:
            return 21600
        case .hour:
            return 3600
        case .thirtyMinutes:
            return 1800
        case .tenMinutes:
            return 600
        }
    }
}
