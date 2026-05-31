import SwiftUI
import SwiftData

@main
struct SpaceLaunchTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FavoriteLaunch.self)
    }
}
