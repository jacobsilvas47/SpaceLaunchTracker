import SwiftUI

struct NotificationReminderDetailView: View {

    let notification: ScheduledLaunchNotification

    @State private var selectedNotificationOffsets: Set<NotificationOffset> = []

    private var launch: Launch {
        Launch(
            id: notification.launchId,
            name: notification.title,
            net: notification.launchDate,
            status: nil,
            launchServiceProvider: nil,
            rocket: nil,
            pad: nil,
            image: nil,
            infographic: nil
        )
    }

    var body: some View {
        NotificationOptionsView(
            launch: launch,
            selectedNotificationOffsets: $selectedNotificationOffsets
        )
    }
}
