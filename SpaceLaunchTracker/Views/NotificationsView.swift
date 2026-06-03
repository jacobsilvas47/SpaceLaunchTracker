import SwiftUI

struct NotificationsView: View {

    @State private var scheduledNotifications: [ScheduledLaunchNotification] = []

    var body: some View {

        NavigationStack {
            List {
                ForEach(scheduledNotifications) { notification in
                    NavigationLink {
                        NotificationReminderDetailView(notification: notification)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(notification.title)
                                .font(.headline)

                            Text("\(notification.offsets.count) reminder(s) scheduled")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear All") {
                        NotificationManager.shared.cancelAllNotifications()
                        scheduledNotifications = []
                    }
                }
            }
            .overlay {
                if scheduledNotifications.isEmpty {
                    ContentUnavailableView(
                        "No Notifications Yet",
                        systemImage: "bell",
                        description: Text("Scheduled launch reminders will appear here.")
                    )
                }
            }
            .onAppear {
                NotificationManager.shared.getAllScheduledNotifications { notifications in
                    DispatchQueue.main.async {
                        scheduledNotifications = notifications
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
