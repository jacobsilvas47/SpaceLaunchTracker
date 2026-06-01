import SwiftUI
import SwiftData

@main
struct SpaceLaunchTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationManager.shared.requestPermission()
                }
        }
        .modelContainer(for: FavoriteLaunch.self)
    }
}
