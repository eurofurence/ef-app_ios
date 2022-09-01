import Foundation.NSDate

public struct SynchronizationPayload: Decodable {
    
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
    
    public var currentDate: Date
    public var conventionIdentifier: String
    public var days: SynchronizationPayload.Update<RemoteDay>
    public var tracks: SynchronizationPayload.Update<RemoteTrack>
    public var rooms: SynchronizationPayload.Update<RemoteRoom>
    public var events: SynchronizationPayload.Update<RemoteEvent>
    public var images: SynchronizationPayload.Update<RemoteImage>
    public var knowledgeGroups: SynchronizationPayload.Update<RemoteKnowledgeGroup>
    public var knowledgeEntries: SynchronizationPayload.Update<RemoteKnowledgeEntry>
    public var dealers: SynchronizationPayload.Update<RemoteDealer>
    
}

// MARK: - Update Nodes

extension SynchronizationPayload {
    
    public struct Update<E>: Decodable where E: RemoteEntity {
        
        private enum CodingKeys: String, CodingKey {
            case changed = "ChangedEntities"
        }
        
        public var changed: [E]
        
    }
    
}
