import Foundation.NSDate

public struct SynchronizationPayload: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case synchronizationToken = "CurrentDateTimeUtc"
        case conventionIdentifier = "ConventionIdentifier"
        case days = "EventConferenceDays"
        case tracks = "EventConferenceTracks"
        case rooms = "EventConferenceRooms"
        case events = "Events"
        case images = "Images"
        case knowledgeGroups = "KnowledgeGroups"
        case knowledgeEntries = "KnowledgeEntries"
        case dealers = "Dealers"
        case announcements = "Announcements"
        case maps = "Maps"
    }
    
    public var synchronizationToken: GenerationToken
    public var conventionIdentifier: String
    public var days: SynchronizationPayload.Update<Day>
    public var tracks: SynchronizationPayload.Update<Track>
    public var rooms: SynchronizationPayload.Update<Room>
    public var events: SynchronizationPayload.Update<Event>
    public var images: SynchronizationPayload.Update<Image>
    public var knowledgeGroups: SynchronizationPayload.Update<KnowledgeGroup>
    public var knowledgeEntries: SynchronizationPayload.Update<KnowledgeEntry>
    public var dealers: SynchronizationPayload.Update<Dealer>
    public var announcements: SynchronizationPayload.Update<Announcement>
    public var maps: SynchronizationPayload.Update<Map>
    
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

// MARK: - History Tracking

extension SynchronizationPayload {
    
    public struct GenerationToken: Codable, CustomStringConvertible, Equatable {
        
        let lastSyncTime: Date
        
        public var description: String {
            EurofurenceISO8601DateFormatter.instance.string(from: lastSyncTime)
        }
        
        public init(lastSyncTime: Date) {
            self.lastSyncTime = lastSyncTime
        }
        
        public init(from decoder: Decoder) throws {
            let singleValueContainer = try decoder.singleValueContainer()
            lastSyncTime = try singleValueContainer.decode(Date.self)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(lastSyncTime)
        }
        
    }
    
}
