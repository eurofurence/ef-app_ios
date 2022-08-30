import Foundation

struct RemoteSyncResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case days = "EventConferenceDays"
        case tracks = "EventConferenceTracks"
    }
    
    var days: RemoteEntityNode<RemoteDay>
    var tracks: RemoteEntityNode<RemoteTrack>
    
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
