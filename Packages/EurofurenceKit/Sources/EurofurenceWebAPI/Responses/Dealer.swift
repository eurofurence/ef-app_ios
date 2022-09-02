import Foundation.NSDate

public struct Dealer: APIEntity {
    
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
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var registrationNumber: Int
    public var attendeeNickname: String
    public var displayName: String
    public var merchandise: String
    public var shortDescription: String
    public var aboutTheArtistText: String
    public var aboutTheArtText: String
    public var links: [Link]?
    public var twitterHandle: String
    public var telegramHandle: String
    public var attendsOnThursday: Bool
    public var attendsOnFriday: Bool
    public var attendsOnSaturday: Bool
    public var artPreviewCaption: String
    public var artistThumbnailImageId: String?
    public var artistImageId: String?
    public var artPreviewImageId: String?
    public var isAfterDark: Bool
    public var categories: [String]
    
}
