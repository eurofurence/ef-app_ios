import Foundation

struct RemoteSyncResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case currentDate = "CurrentDateTimeUtc"
        case conventionIdentifier = "ConventionIdentifier"
        case days = "EventConferenceDays"
        case tracks = "EventConferenceTracks"
        case rooms = "EventConferenceRooms"
        case events = "Events"
        case images = "Images"
        case knowledgeGroups = "KnowledgeGroups"
        case knowledgeEntries = "KnowledgeEntries"
    }
    
    var currentDate: Date
    var conventionIdentifier: String
    var days: RemoteEntityNode<RemoteDay>
    var tracks: RemoteEntityNode<RemoteTrack>
    var rooms: RemoteEntityNode<RemoteRoom>
    var events: RemoteEntityNode<RemoteEvent>
    var images: RemoteEntityNode<RemoteImage>
    var knowledgeGroups: RemoteEntityNode<RemoteKnowledgeGroup>
    var knowledgeEntries: RemoteEntityNode<RemoteKnowledgeEntry>
    
}

struct RemoteEntityNode<T>: Decodable where T: Decodable & Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case changed = "ChangedEntities"
    }
    
    var changed: [T]
    
}

struct RemoteDay: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case date = "Date"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var date: Date
    
}

struct RemoteTrack: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    
}

struct RemoteRoom: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case shortName = "ShortName"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var shortName: String
    
}

struct RemoteEvent: Decodable, Identifiable {
    
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

struct RemoteImage: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case internalReference = "InternalReference"
        case width = "Width"
        case height = "Height"
        case sizeInBytes = "SizeInBytes"
        case mimeType = "MimeType"
        case contentHashSha1 = "ContentHashSha1"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var internalReference: String
    var width: Int
    var height: Int
    var sizeInBytes: Int
    var mimeType: String
    var contentHashSha1: String
    
}

struct RemoteKnowledgeGroup: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case description = "Description"
        case order = "Order"
        case fontAwesomeIconCharacterUnicodeAddress = "FontAwesomeIconCharacterUnicodeAddress"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var description: String
    var order: Int
    var fontAwesomeIconCharacterUnicodeAddress: String
    
}

struct RemoteKnowledgeEntry: Decodable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case knowledgeGroupIdentifier = "KnowledgeGroupId"
        case title = "Title"
        case text = "Text"
        case order = "Order"
        case links = "Links"
        case imageIdentifiers = "ImageIds"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var knowledgeGroupIdentifier: String
    var title: String
    var text: String
    var order: Int
    var links: [RemoteLink]
    var imageIdentifiers: [String]
    
}

struct RemoteLink: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case fragmentType = "FragmentType"
        case name = "Name"
        case target = "Target"
    }
    
    var fragmentType: String
    var name: String
    var target: String
    
}
