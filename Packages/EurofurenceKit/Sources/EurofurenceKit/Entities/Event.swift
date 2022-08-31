import CoreData

@objc(Event)
public class Event: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var acceptingFeedback: Bool
    @NSManaged public var deviatingFromConbook: Bool
    @NSManaged public var endDate: Date
    @NSManaged public var eventDescription: String
    @NSManaged public var slug: String
    @NSManaged public var startDate: Date
    @NSManaged public var subtitle: String
    @NSManaged public var title: String
    @NSManaged public var banner: EventBanner?
    @NSManaged public var day: Day
    @NSManaged public var panelHosts: Set<PanelHost>
    @NSManaged public var poster: EventPoster?
    @NSManaged public var room: Room
    @NSManaged public var tracks: Set<Track>
    @NSManaged public var tags: Set<Tag>

}

// MARK: - Event + ConsumesRemoteResponse

extension Event: ConsumesRemoteResponse {
    
    typealias RemoteResponse = RemoteEvent
    
    func update(from remoteResponse: RemoteEvent) throws {
        identifier = remoteResponse.Id
        lastEdited = remoteResponse.LastChangeDateTimeUtc
        slug = remoteResponse.Slug
        title = remoteResponse.Title
        subtitle = remoteResponse.SubTitle
        abstract = remoteResponse.Abstract
        day = try managedObjectContext!.entity(withIdentifier: remoteResponse.ConferenceDayId)
        
        let track: Track = try managedObjectContext!.entity(withIdentifier: remoteResponse.ConferenceTrackId)
        addToTracks(track)
        
        room = try managedObjectContext!.entity(withIdentifier: remoteResponse.ConferenceRoomId)
        eventDescription = remoteResponse.Description
        startDate = remoteResponse.StartDateTimeUtc
        endDate = remoteResponse.EndDateTimeUtc
        
        let hosts = remoteResponse.PanelHosts.components(separatedBy: ",")
        for host in hosts {
            let trimmedHost = host.trimmingCharacters(in: .whitespaces)
            let host = PanelHost(context: managedObjectContext!)
            host.name = trimmedHost
            addToPanelHosts(host)
        }
        
        for remoteTag in remoteResponse.Tags {
            let tag = Tag(context: managedObjectContext!)
            tag.name = remoteTag
            addToTags(tag)
        }
        
        deviatingFromConbook = remoteResponse.IsDeviatingFromConBook
        acceptingFeedback = remoteResponse.IsAcceptingFeedback
    }
    
}

// MARK: - Core Data Generated Accessors

extension Event {
    
    // MARK: Panel Hosts

    @objc(addPanelHostsObject:)
    @NSManaged func addToPanelHosts(_ value: PanelHost)

    @objc(removePanelHostsObject:)
    @NSManaged func removeFromPanelHosts(_ value: PanelHost)

    @objc(addPanelHosts:)
    @NSManaged func addToPanelHosts(_ values: Set<PanelHost>)

    @objc(removePanelHosts:)
    @NSManaged func removeFromPanelHosts(_ values: Set<PanelHost>)

    
    // MARK: Tracks

    @objc(addTracksObject:)
    @NSManaged func addToTracks(_ value: Track)

    @objc(removeTracksObject:)
    @NSManaged func removeFromTracks(_ value: Track)

    @objc(addTracks:)
    @NSManaged func addToTracks(_ values: Set<Track>)

    @objc(removeTracks:)
    @NSManaged func removeFromTracks(_ values: Set<Track>)

    
    // MARK: Tags

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
