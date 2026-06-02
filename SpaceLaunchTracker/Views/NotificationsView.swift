import SwiftUI

struct NotificationsView: View {

    var body: some View {

        NavigationStack {

            ContentUnavailableView(
                "No Notifications Yet",
                systemImage: "bell",
                description: Text(
                    "Scheduled launch reminders will appear here."
                )
            )
            .navigationTitle("Notifications")
        }
    }
}

#Preview {
    NotificationsView()
}
