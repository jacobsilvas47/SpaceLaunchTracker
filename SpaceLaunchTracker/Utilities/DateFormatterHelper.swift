import Foundation

enum DateFormatterHelper {

    static func formattedDate(from dateString: String) -> String {

        let inputFormatter = ISO8601DateFormatter()

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none

        return outputFormatter.string(from: date)
    }
}
