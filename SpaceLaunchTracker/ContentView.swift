import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LaunchListView()
                .tabItem {
                    Label("Launches", systemImage: "paperplane.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
