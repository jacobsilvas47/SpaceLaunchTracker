import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @Query(sort: \FavoriteLaunch.launchDate) private var favorites: [FavoriteLaunch]
    
    var body: some View {
        NavigationStack {
            List(favorites) { favorite in
                NavigationLink {
                    FavoriteLaunchDetailView(favorite: favorite)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(favorite.name)
                            .font(.headline)
                        
                        Text(favorite.rocketName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(favorite.providerName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(favorite.locationName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(DateFormatterHelper.formattedDate(from: favorite.launchDate))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Favorites")
            .overlay {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "star",
                        description: Text("Favorite launches from the launch detail screen.")
                    )
                }
            }
        }
    }
}
