import SwiftUI
import SwiftData

struct LaunchListView: View {
    
    @StateObject private var viewModel = LaunchListViewModel()
    @State private var searchText = ""
    @State private var selectedLocation = "All"
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteLaunch]
    
    private let locations = [
        "All",
        "Vandenberg",
        "Kennedy",
        "Boca Chica",
        "Wallops"
    ]
    
    private var filteredLaunches: [Launch] {

        viewModel.launches.filter { launch in

            let matchesSearch =
            searchText.isEmpty ||
            launch.name.localizedCaseInsensitiveContains(searchText) ||
            (launch.rocket?.configuration?.name.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.launchServiceProvider?.name.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.pad?.location?.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.status?.name.localizedCaseInsensitiveContains(searchText) ?? false)

            let matchesLocation =
            selectedLocation == "All" ||
            (launch.pad?.location?.name?.localizedCaseInsensitiveContains(selectedLocation) ?? false)

            return matchesSearch && matchesLocation
        }
    }
    
    private func isFavorite(_ launch: Launch) -> Bool {
        favorites.contains { $0.id == launch.id }
    }

    private func toggleFavorite(_ launch: Launch) {
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
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView()
                    
                } else if let error = viewModel.errorMessage,
                          viewModel.launches.isEmpty {
                    Text(error)
                } else {

                    List(filteredLaunches) { launch in
                        
                        NavigationLink {
                            LaunchDetailView(launch: launch)
                        } label: {
                            
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: launch.launchServiceProvider?.logoUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Image(systemName: "paperplane.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: 36, height: 36)

                                VStack(alignment: .leading, spacing: 6) {

                                    Text(launch.name)
                                        .font(.headline)

                                    Text(launch.rocket?.configuration?.name ?? "Unknown Rocket")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text(launch.launchServiceProvider?.name ?? "Unknown Provider")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    Text(launch.pad?.location?.name ?? "Unknown Location")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    Text(
                                        DateFormatterHelper.formattedDate(
                                            from: launch.net
                                        )
                                    )
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Button {
                                    toggleFavorite(launch)
                                } label: {
                                    Image(systemName: isFavorite(launch) ? "star.fill" : "star")
                                        .font(.title3)
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .refreshable {
                        await viewModel.loadLaunches()
                    }
                }
            }
            .navigationTitle("Launches")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(locations, id: \.self) { location in
                            Button {
                                selectedLocation = location
                            } label: {
                                if selectedLocation == location {
                                    Label(location, systemImage: "checkmark")
                                } else {
                                    Text(location)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .searchable(
                text: $searchText,
                prompt: "Search launches"
            )
            .task {
                await viewModel.loadLaunches()
            }
        }
    }
}

#Preview {
    LaunchListView()
}
