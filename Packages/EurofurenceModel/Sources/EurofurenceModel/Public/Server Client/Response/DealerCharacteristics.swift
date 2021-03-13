import Foundation

public struct DealerCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var displayName: String
    public var attendeeNickname: String
    public var attendsOnThursday: Bool
    public var attendsOnFriday: Bool
    public var attendsOnSaturday: Bool
    public var isAfterDark: Bool
    public var artistThumbnailImageId: String?
    public var artistImageId: String?
    public var artPreviewImageId: String?
    public var categories: [String]
    public var shortDescription: String
    public var links: [LinkCharacteristics]?
    public var twitterHandle: String
    public var telegramHandle: String
    public var aboutTheArtistText: String
    public var aboutTheArtText: String
    public var artPreviewCaption: String
    
    public init(
        identifier: String,
        displayName: String,
        attendeeNickname: String,
        attendsOnThursday: Bool,
        attendsOnFriday: Bool,
        attendsOnSaturday: Bool,
        isAfterDark: Bool,
        artistThumbnailImageId: String?,
        artistImageId: String?,
        artPreviewImageId: String?,
        categories: [String],
        shortDescription: String,
        links: [LinkCharacteristics]?,
        twitterHandle: String,
        telegramHandle: String,
        aboutTheArtistText: String,
        aboutTheArtText: String,
        artPreviewCaption: String
    ) {
        self.identifier = identifier
        self.displayName = displayName
        self.attendeeNickname = attendeeNickname
        self.attendsOnThursday = attendsOnThursday
        self.attendsOnFriday = attendsOnFriday
        self.attendsOnSaturday = attendsOnSaturday
        self.isAfterDark = isAfterDark
        self.artistThumbnailImageId = artistThumbnailImageId
        self.artistImageId = artistImageId
        self.artPreviewImageId = artPreviewImageId
        self.categories = categories
        self.shortDescription = shortDescription
        self.links = links
        self.twitterHandle = twitterHandle
        self.telegramHandle = telegramHandle
        self.aboutTheArtistText = aboutTheArtistText
        self.aboutTheArtText = aboutTheArtText
        self.artPreviewCaption = artPreviewCaption
    }

}
