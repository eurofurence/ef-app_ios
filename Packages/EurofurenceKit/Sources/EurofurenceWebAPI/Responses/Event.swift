import Foundation.NSDate

public struct Event: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case slug = "Slug"
        case title = "Title"
        case subtitle = "SubTitle"
        case abstract = "Abstract"
        case dayIdentifier = "ConferenceDayId"
        case trackIdentifier = "ConferenceTrackId"
        case roomIdentifier = "ConferenceRoomId"
        case description = "Description"
        case startDateTimeUtc = "StartDateTimeUtc"
        case endDateTimeUtc = "EndDateTimeUtc"
        case panelHostsSeperatedByComma = "PanelHosts"
        case isDeviatingFromConBook = "IsDeviatingFromConBook"
        case isAcceptingFeedback = "IsAcceptingFeedback"
        case tags = "Tags"
        case bannerImageIdentifier = "BannerImageId"
        case posterImageIdentifier = "PosterImageId"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var slug: String
    public var title: String
    public var subtitle: String
    public var abstract: String
    public var dayIdentifier: String
    public var trackIdentifier: String
    public var roomIdentifier: String
    public var description: String
    public var startDateTimeUtc: Date
    public var endDateTimeUtc: Date
    public var panelHostsSeperatedByComma: String
    public var isDeviatingFromConBook: Bool
    public var isAcceptingFeedback: Bool
    public var tags: [String]
    public var bannerImageIdentifier: String?
    public var posterImageIdentifier: String?
    
}
