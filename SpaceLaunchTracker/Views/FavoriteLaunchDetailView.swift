import SwiftUI

struct FavoriteLaunchDetailView: View {

    let favorite: FavoriteLaunch

    var body: some View {
        List {
            Section("Mission") {
                detailRow("Mission Name", favorite.name)
                detailRow("Rocket", favorite.rocketName)
                detailRow("Provider", favorite.providerName)
            }

            Section("Launch Info") {
                detailRow(
                    "Launch Date",
                    DateFormatterHelper.formattedDate(from: favorite.launchDate)
                )

                detailRow("Location", favorite.locationName)

                detailRow(
                    "Countdown",
                    CountdownHelper.countdownText(from: favorite.launchDate)
                )
            }
        }
        .navigationTitle("Favorite Launch")
        .navigationBarTitleDisplayMode(.inline)
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
