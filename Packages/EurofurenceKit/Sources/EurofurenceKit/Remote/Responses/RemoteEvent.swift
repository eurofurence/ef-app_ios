import Foundation.NSDate

struct RemoteEvent: RemoteEntity {
    
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
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var slug: String
    var title: String
    var subtitle: String
    var abstract: String
    var dayIdentifier: String
    var trackIdentifier: String
    var roomIdentifier: String
    var description: String
    var startDateTimeUtc: Date
    var endDateTimeUtc: Date
    var panelHostsSeperatedByComma: String
    var isDeviatingFromConBook: Bool
    var isAcceptingFeedback: Bool
    var tags: [String]
    var bannerImageIdentifier: String?
    var posterImageIdentifier: String?
    
}
