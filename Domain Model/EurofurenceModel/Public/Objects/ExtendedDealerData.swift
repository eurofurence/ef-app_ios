import Foundation

public struct ExtendedDealerData {

    public var artistImagePNGData: Data?
    public var dealersDenMapLocationGraphicPNGData: Data?
    public var preferredName: String
    public var alternateName: String?
    public var categories: [String]
    public var dealerShortDescription: String
    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool
    public var isAfterDark: Bool
    public var websiteName: String?
    public var twitterUsername: String?
    public var telegramUsername: String?
    public var aboutTheArtist: String?
    public var aboutTheArt: String?
    public var artPreviewImagePNGData: Data?
    public var artPreviewCaption: String?

    public init(artistImagePNGData: Data?,
                dealersDenMapLocationGraphicPNGData: Data?,
                preferredName: String,
                alternateName: String?,
                categories: [String],
                dealerShortDescription: String,
                isAttendingOnThursday: Bool,
                isAttendingOnFriday: Bool,
                isAttendingOnSaturday: Bool,
                isAfterDark: Bool,
                websiteName: String?,
                twitterUsername: String?,
                telegramUsername: String?,
                aboutTheArtist: String?,
                aboutTheArt: String?,
                artPreviewImagePNGData: Data?,
                artPreviewCaption: String?) {
        self.artistImagePNGData = artistImagePNGData
        self.dealersDenMapLocationGraphicPNGData = dealersDenMapLocationGraphicPNGData
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.categories = categories
        self.dealerShortDescription = dealerShortDescription
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
        self.websiteName = websiteName
        self.twitterUsername = twitterUsername
        self.telegramUsername = telegramUsername
        self.aboutTheArtist = aboutTheArtist
        self.aboutTheArt = aboutTheArt
        self.artPreviewImagePNGData = artPreviewImagePNGData
        self.artPreviewCaption = artPreviewCaption
    }

}
