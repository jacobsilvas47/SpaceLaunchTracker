import Foundation

final class LaunchAPIService {

    func fetchUpcomingLaunches() async throws -> [Launch] {

        let urlString =
        "https://ll.thespacedevs.com/2.2.0/launch/upcoming/?limit=50"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decodedResponse =
        try JSONDecoder().decode(
            LaunchResponse.self,
            from: data
        )

        return decodedResponse.results
    }
}
