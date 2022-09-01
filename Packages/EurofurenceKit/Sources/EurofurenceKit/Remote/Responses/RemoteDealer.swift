import Foundation.NSDate

struct RemoteDealer: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case registrationNumber = "RegistrationNumber"
        case attendeeNickname = "AttendeeNickname"
        case displayName = "DisplayName"
        case merchandise = "Merchandise"
        case shortDescription = "ShortDescription"
        case aboutTheArtistText = "AboutTheArtistText"
        case aboutTheArtText = "AboutTheArtText"
        case links = "Links"
        case twitterHandle = "TwitterHandle"
        case telegramHandle = "TelegramHandle"
        case attendsOnThursday = "AttendsOnThursday"
        case attendsOnFriday = "AttendsOnFriday"
        case attendsOnSaturday = "AttendsOnSaturday"
        case artPreviewCaption = "ArtPreviewCaption"
        case artistThumbnailImageId = "ArtistThumbnailImageId"
        case artistImageId = "ArtistImageId"
        case artPreviewImageId = "ArtPreviewImageId"
        case isAfterDark = "IsAfterDark"
        case categories = "Categories"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var registrationNumber: Int
    var attendeeNickname: String
    var displayName: String
    var merchandise: String
    var shortDescription: String
    var aboutTheArtistText: String
    var aboutTheArtText: String
    var links: [RemoteLink]?
    var twitterHandle: String
    var telegramHandle: String
    var attendsOnThursday: Bool
    var attendsOnFriday: Bool
    var attendsOnSaturday: Bool
    var artPreviewCaption: String
    var artistThumbnailImageId: String?
    var artistImageId: String?
    var artPreviewImageId: String?
    var isAfterDark: Bool
    var categories: [String]
    
}
