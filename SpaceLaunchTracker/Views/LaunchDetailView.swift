import SwiftUI
import SwiftData
import Combine

struct LaunchDetailView: View {

    let launch: Launch

    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteLaunch]

    @State private var showingNotificationOptions = false
    @State private var selectedNotificationOffsets: Set<NotificationOffset> = []
    @State private var currentDate = Date()

    private let timer = Timer.publish(
        every: 60,
        on: .main,
        in: .common
    ).autoconnect()

    private var isFavorite: Bool {
        favorites.contains { $0.id == launch.id }
    }

    var body: some View {
        List {
            launchImageSection

            Section("Mission") {
                detailRow("Mission Name", launch.name)
                detailRow("Rocket", launch.rocket?.configuration?.name ?? "Unknown Rocket")
                detailRow("Provider", launch.launchServiceProvider?.name ?? "Unknown Provider")
            }

            Section("Launch Info") {
                detailRow("Launch Date", DateFormatterHelper.formattedDate(from: launch.net))
                detailRow("Status", launch.status?.name ?? "Unknown Status")
                detailRow("Location", launch.pad?.location?.name ?? "Unknown Location")
                detailRow("Launch Pad", launch.pad?.name ?? "Unknown Pad")
                detailRow(
                    "Countdown",
                    CountdownHelper.countdownText(
                        from: launch.net,
                        currentDate: currentDate
                    )
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

            Section("Notifications") {
                Button {
                    NotificationManager.shared.getScheduledOffsets(for: launch) { offsets in
                        DispatchQueue.main.async {
                            selectedNotificationOffsets = offsets
                            showingNotificationOptions = true
                        }
                    }
                } label: {
                    Label("Notify Me", systemImage: "bell")
                }
            }
        }
        .navigationTitle("Launch Details")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { date in
            currentDate = date
        }
        .onAppear {
            NotificationManager.shared.getScheduledOffsets(for: launch) { offsets in
                DispatchQueue.main.async {
                    selectedNotificationOffsets = offsets
                }
            }
        }
        .sheet(isPresented: $showingNotificationOptions) {
            NotificationOptionsView(
                launch: launch,
                selectedNotificationOffsets: $selectedNotificationOffsets
            )
        }
    }

    @ViewBuilder
    private var launchImageSection: some View {
        if let imageUrl = launch.image,
           let url = URL(string: imageUrl) {

            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure(_):
                    Image(systemName: "paperplane.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)

                default:
                    ProgressView()
                }
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.quaternary)
            }
            .shadow(radius: 4)
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 8)
        }
    }

    private func toggleFavorite() {
        print("Favorite button tapped")
        print(launch.name)
        print("Currently favorite:", isFavorite)
        
        if let existingFavorite = favorites.first(where: { $0.id == launch.id }) {
            modelContext.delete(existingFavorite)
        } else {
            let favorite = FavoriteLaunch(
                id: launch.id,
                name: launch.name,
                rocketName: launch.rocket?.configuration?.name ?? "Unknown Rocket",
                providerName: launch.launchServiceProvider?.name ?? "Unknown Provider",
                locationName: launch.pad?.location?.name ?? "Unknown Location",
                launchDate: launch.net,
                statusName: launch.status?.name ?? "Unknown Status",
                launchPadName: launch.pad?.name ?? "Unknown Pad",
                imageURL: launch.image ?? ""
            )

            modelContext.insert(favorite)
        }

        do {
            try modelContext.save()
        } catch {
            print("Favorite save error:")
            print(error)
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
