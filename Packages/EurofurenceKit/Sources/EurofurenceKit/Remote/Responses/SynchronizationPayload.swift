import Foundation.NSDate

struct SynchronizationPayload: Decodable {
    
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
    var days: SynchronizationPayload.Update<RemoteDay>
    var tracks: SynchronizationPayload.Update<RemoteTrack>
    var rooms: SynchronizationPayload.Update<RemoteRoom>
    var events: SynchronizationPayload.Update<RemoteEvent>
    var images: SynchronizationPayload.Update<RemoteImage>
    var knowledgeGroups: SynchronizationPayload.Update<RemoteKnowledgeGroup>
    var knowledgeEntries: SynchronizationPayload.Update<RemoteKnowledgeEntry>
    var dealers: SynchronizationPayload.Update<RemoteDealer>
    
}

// MARK: - Update Nodes

extension SynchronizationPayload {
    
    struct Update<T>: Decodable where T: RemoteEntity {
        
        private enum CodingKeys: String, CodingKey {
            case changed = "ChangedEntities"
        }
        
        var changed: [T]
        
    }
    
}
