import Foundation
import SwiftUI
import Combine

@MainActor
final class LaunchListViewModel: ObservableObject {

    @Published var launches: [Launch] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = LaunchAPIService()

    func loadLaunches() async {

        isLoading = true
        errorMessage = nil

        do {
            launches = try await service.fetchUpcomingLaunches()
            
            for launch in launches.prefix(5) {
                print("Provider:",
                      launch.launchServiceProvider?.name ?? "nil")

                print("Logo:",
                      launch.launchServiceProvider?.logoUrl ?? "nil")
            }

            print("Loaded launches:")
            print(launches.count)

        } catch is CancellationError {

            print("Request was cancelled")
            isLoading = false
            return

        } catch {

            errorMessage = error.localizedDescription

            print("Error:")
            print(error)
        }

        isLoading = false
    }
}
