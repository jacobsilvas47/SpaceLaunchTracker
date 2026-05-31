import Foundation

struct LaunchResponse: Codable {
    let results: [Launch]
}

struct Launch: Codable, Identifiable {
    let id: String
    let name: String
    let net: String
    let status: LaunchStatus?
    let launchServiceProvider: LaunchServiceProvider?
    let rocket: Rocket?
    let pad: LaunchPad?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case net
        case status
        case launchServiceProvider = "launch_service_provider"
        case rocket
        case pad
    }
}

struct LaunchStatus: Codable {
    let name: String
}

struct LaunchServiceProvider: Codable {
    let name: String
}

struct Rocket: Codable {
    let configuration: RocketConfiguration?
}

struct RocketConfiguration: Codable {
    let name: String
}

struct LaunchPad: Codable {
    let name: String?
    let location: LaunchLocation?
}

struct LaunchLocation: Codable {
    let name: String?
}
