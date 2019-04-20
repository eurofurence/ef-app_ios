import Foundation

public struct EventCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var roomIdentifier: String
    public var trackIdentifier: String
    public var dayIdentifier: String
    public var startDateTime: Date
    public var endDateTime: Date
    public var title: String
    public var subtitle: String
    public var abstract: String
    public var panelHosts: String
    public var eventDescription: String
    public var posterImageId: String?
    public var bannerImageId: String?
    public var tags: [String]?
    public var isAcceptingFeedback: Bool

    public init(identifier: String,
                roomIdentifier: String,
                trackIdentifier: String,
                dayIdentifier: String,
                startDateTime: Date,
                endDateTime: Date,
                title: String,
                subtitle: String,
                abstract: String,
                panelHosts: String,
                eventDescription: String,
                posterImageId: String?,
                bannerImageId: String?,
                tags: [String]?,
                isAcceptingFeedback: Bool) {
        self.identifier = identifier
        self.roomIdentifier = roomIdentifier
        self.trackIdentifier = trackIdentifier
        self.dayIdentifier = dayIdentifier
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.panelHosts = panelHosts
        self.eventDescription = eventDescription
        self.posterImageId = posterImageId
        self.bannerImageId = bannerImageId
        self.tags = tags
        self.isAcceptingFeedback = isAcceptingFeedback
    }

}
