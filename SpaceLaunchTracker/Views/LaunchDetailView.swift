import SwiftUI
import SwiftData

struct LaunchDetailView: View {

    let launch: Launch

    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteLaunch]

    private var isFavorite: Bool {
        favorites.contains { $0.id == launch.id }
    }

    var body: some View {

        List {

            Section("Mission") {
                detailRow("Mission Name", launch.name)
                detailRow("Rocket", launch.rocket?.configuration?.name ?? "Unknown Rocket")
                detailRow("Provider", launch.launchServiceProvider?.name ?? "Unknown Provider")
            }

            Section("Launch Info") {
                detailRow(
                    "Launch Date",
                    DateFormatterHelper.formattedDate(from: launch.net)
                )

                detailRow("Status", launch.status?.name ?? "Unknown Status")

                detailRow(
                    "Location",
                    launch.pad?.location?.name ?? "Unknown Location"
                )

                detailRow(
                    "Launch Pad",
                    launch.pad?.name ?? "Unknown Pad"
                )

                detailRow(
                    "Countdown",
                    CountdownHelper.countdownText(from: launch.net)
                )
            }

            Section {
                Button {
                    toggleFavorite()
                } label: {
                    Label(
                        isFavorite ? "Remove from Favorites" : "Add to Favorites",
                        systemImage: isFavorite ? "star.fill" : "star"
                    )
                }
            }
        }
        .navigationTitle("Launch Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleFavorite() {
        if let existingFavorite = favorites.first(where: { $0.id == launch.id }) {
            modelContext.delete(existingFavorite)
        } else {
            let favorite = FavoriteLaunch(
                id: launch.id,
                name: launch.name,
                rocketName: launch.rocket?.configuration?.name ?? "Unknown Rocket",
                providerName: launch.launchServiceProvider?.name ?? "Unknown Provider",
                locationName: launch.pad?.location?.name ?? "Unknown Location",
                launchDate: launch.net
            )

            modelContext.insert(favorite)
        }
    }

    private func detailRow(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}
