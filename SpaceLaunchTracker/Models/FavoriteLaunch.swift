import Foundation
import SwiftData

@Model
final class FavoriteLaunch {
    @Attribute(.unique) var id: String

    var name: String
    var rocketName: String
    var providerName: String
    var locationName: String
    var launchDate: String

    var statusName: String
    var launchPadName: String
    var imageURL: String

    init(
        id: String,
        name: String,
        rocketName: String,
        providerName: String,
        locationName: String,
        launchDate: String,
        statusName: String,
        launchPadName: String,
        imageURL: String
    ) {
        self.id = id
        self.name = name
        self.rocketName = rocketName
        self.providerName = providerName
        self.locationName = locationName
        self.launchDate = launchDate
        self.statusName = statusName
        self.launchPadName = launchPadName
        self.imageURL = imageURL
    }
}
