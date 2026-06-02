import Foundation

enum CountdownHelper {
    
    static func countdownText(
        from dateString: String,
        currentDate: Date = Date()
    ) -> String {
        
        let formatter = ISO8601DateFormatter()
        
        guard let launchDate = formatter.date(from: dateString) else {
            return "Countdown unavailable"
        }
        
        if launchDate <= currentDate {
            return "Launched"
        }
        
        let components = Calendar.current.dateComponents(
            [.day, .hour, .minute],
            from: currentDate,
            to: launchDate
        )
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        if days > 0 {
            return "T-\(days)d \(hours)h \(minutes)m"
        } else if hours > 0 {
            return "T-\(hours)h \(minutes)m"
        } else {
            return "T-\(minutes)m"
        }
    }
}
