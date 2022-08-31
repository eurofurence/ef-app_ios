import Foundation

struct RemoteSyncResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case conventionIdentifier = "ConventionIdentifier"
        case days = "EventConferenceDays"
        case tracks = "EventConferenceTracks"
        case rooms = "EventConferenceRooms"
        case events = "Events"
    }
    
    var conventionIdentifier: String
    var days: RemoteEntityNode<RemoteDay>
    var tracks: RemoteEntityNode<RemoteTrack>
    var rooms: RemoteEntityNode<RemoteRoom>
    var events: RemoteEntityNode<RemoteEvent>
    
}

struct RemoteEntityNode<T>: Decodable where T: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case changed = "ChangedEntities"
    }
    
    var changed: [T]
    
}

struct RemoteDay: Decodable {
    
    var LastChangeDateTimeUtc: Date
    var Id: String
    var Name: String
    var Date: Date
    
}

struct RemoteTrack: Decodable {
    
    var LastChangeDateTimeUtc: Date
    var Id: String
    var Name: String
    
}

struct RemoteRoom: Decodable {
    
    var LastChangeDateTimeUtc: Date
    var Id: String
    var Name: String
    var ShortName: String
    
}

struct RemoteEvent: Decodable {
    
    var LastChangeDateTimeUtc: Date
    var Id: String
    var Slug: String
    var Title: String
    var SubTitle: String
    var Abstract: String
    var ConferenceDayId: String
    var ConferenceTrackId: String
    var ConferenceRoomId: String
    var Description: String
    var StartDateTimeUtc: Date
    var EndDateTimeUtc: Date
    var PanelHosts: String
    var IsDeviatingFromConBook: Bool
    var IsAcceptingFeedback: Bool
    
}
