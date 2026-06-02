import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() { }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in

            if let error = error {
                print("Notification permission error:")
                print(error)
            }

            print("Notification permission granted:")
            print(granted)
        }
    }
    
    func scheduleNotification(
        for launch: Launch,
        offset: NotificationOffset
    ) {
        let formatter = ISO8601DateFormatter()

        guard let launchDate = formatter.date(from: launch.net) else {
            print("Could not read launch date")
            return
        }

        let notificationDate =
        launchDate.addingTimeInterval(-offset.seconds)

        if notificationDate <= Date() {
            print("Notification time is already in the past")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = launch.name
        content.body = "Launch starts in \(offset.rawValue.lowercased())."
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: notificationDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "\(launch.id)-\(offset.rawValue)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error:")
                print(error)
            } else {
                print("Notification scheduled:")
                print(launch.name)
                print(offset.rawValue)
            }
        }
    }
    
    func cancelNotification(
        for launch: Launch,
        offset: NotificationOffset
    ) {
        let identifier = "\(launch.id)-\(offset.rawValue)"

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [identifier]
            )

        print("Notification cancelled:")
        print(launch.name)
        print(offset.rawValue)
    }

    func getScheduledOffsets(
        for launch: Launch,
        completion: @escaping (Set<NotificationOffset>) -> Void
    ) {
        UNUserNotificationCenter.current()
            .getPendingNotificationRequests { requests in

                let scheduledOffsets = requests.compactMap { request -> NotificationOffset? in
                    for offset in NotificationOffset.allCases {
                        let identifier = "\(launch.id)-\(offset.rawValue)"

                        if request.identifier == identifier {
                            return offset
                        }
                    }

                    return nil
                }

                completion(Set(scheduledOffsets))
            }
    }
}
