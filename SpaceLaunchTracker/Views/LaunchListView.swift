import SwiftUI

struct LaunchListView: View {
    
    @StateObject private var viewModel = LaunchListViewModel()
    @State private var searchText = ""
    @State private var selectedLocation = "All"
    
    private let locations = [
        "All",
        "Vandenberg",
        "Kennedy",
        "Boca Chica",
        "Wallops"
    ]
    
    private var filteredLaunches: [Launch] {
        
        if searchText.isEmpty {
            return viewModel.launches
        }
        
        return viewModel.launches.filter { launch in
            
            launch.name.localizedCaseInsensitiveContains(searchText) ||
            (launch.rocket?.configuration?.name.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.launchServiceProvider?.name.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.pad?.location?.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (launch.status?.name.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView()
                    
                } else if let error = viewModel.errorMessage {
                    
                    Text(error)
                    
                } else {

                    List(filteredLaunches) { launch in
                        
                        NavigationLink {
                            LaunchDetailView(launch: launch)
                        } label: {
                            
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
