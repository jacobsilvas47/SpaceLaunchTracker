import SwiftUI

struct NotificationOptionsView: View {

    let launch: Launch
    @Binding var selectedNotificationOffsets: Set<NotificationOffset>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(NotificationOffset.allCases, id: \.self) { offset in
                    Button {
                        if selectedNotificationOffsets.contains(offset) {
                            selectedNotificationOffsets.remove(offset)

                            NotificationManager.shared.cancelNotification(
                                for: launch,
                                offset: offset
                            )
                        } else {
                            selectedNotificationOffsets.insert(offset)

                            NotificationManager.shared.scheduleNotification(
                                for: launch,
                                offset: offset
                            )
                        }
                    } label: {
                        HStack {
                            Text(offset.rawValue)

                            Spacer()

                            if selectedNotificationOffsets.contains(offset) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Notifications")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        NotificationManager.shared.cancelAllNotifications(for: launch)
                        selectedNotificationOffsets = []
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            NotificationManager.shared.getScheduledOffsets(for: launch) { offsets in
                DispatchQueue.main.async {
                    selectedNotificationOffsets = offsets
                }
            }
        }
    }
}
