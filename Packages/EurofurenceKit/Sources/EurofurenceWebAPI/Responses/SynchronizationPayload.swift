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
    public var days: SynchronizationPayload.Update<Day>
    public var tracks: SynchronizationPayload.Update<Track>
    public var rooms: SynchronizationPayload.Update<Room>
    public var events: SynchronizationPayload.Update<Event>
    public var images: SynchronizationPayload.Update<Image>
    public var knowledgeGroups: SynchronizationPayload.Update<KnowledgeGroup>
    public var knowledgeEntries: SynchronizationPayload.Update<KnowledgeEntry>
    public var dealers: SynchronizationPayload.Update<Dealer>
    
}

// MARK: - Update Nodes

extension SynchronizationPayload {
    
    public struct Update<E>: Decodable where E: APIEntity {
        
        private enum CodingKeys: String, CodingKey {
            case changed = "ChangedEntities"
        }
        
        public var changed: [E]
        
    }
    
}