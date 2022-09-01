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
        case dealers = "Dealers"
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
    var dealers: RemoteEntityNode<RemoteDealer>
    
}

protocol RemoteEntity: Decodable, Identifiable {
    
    var id: String { get }
    
}

struct RemoteEntityNode<T>: Decodable where T: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case changed = "ChangedEntities"
    }
    
    var changed: [T]
    
}

struct RemoteDay: RemoteEntity {
    
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

struct RemoteTrack: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    
}

struct RemoteRoom: RemoteEntity {
    
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

struct RemoteImage: RemoteEntity {
    
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

struct RemoteKnowledgeGroup: RemoteEntity {
    
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

struct RemoteKnowledgeEntry: RemoteEntity {
    
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
