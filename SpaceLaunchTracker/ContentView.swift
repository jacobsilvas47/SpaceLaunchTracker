import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LaunchListView()
                .tabItem {
                    Label("Launches", systemImage: "rocket")
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
