import CoreData

@objc(Event)
public class Event: Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
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
        day = try managedObjectContext!.object(matching: NSPredicate(format: "identifier == %@", remoteResponse.ConferenceDayId))
        
        let track: Track = try managedObjectContext!.entity(withIdentifier: remoteResponse.ConferenceTrackId)
        addToTracks(track)
        
        room = try managedObjectContext!.object(matching: NSPredicate(format: "identifier == %@", remoteResponse.ConferenceRoomId))
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
        
        deviatingFromConbook = remoteResponse.IsDeviatingFromConBook
        acceptingFeedback = remoteResponse.IsAcceptingFeedback
    }
    
}

// MARK: Generated accessors for panelHosts
extension Event {

    @objc(addPanelHostsObject:)
    @NSManaged func addToPanelHosts(_ value: PanelHost)

    @objc(removePanelHostsObject:)
    @NSManaged func removeFromPanelHosts(_ value: PanelHost)

    @objc(addPanelHosts:)
    @NSManaged func addToPanelHosts(_ values: Set<PanelHost>)

    @objc(removePanelHosts:)
    @NSManaged func removeFromPanelHosts(_ values: Set<PanelHost>)

}

// MARK: Generated accessors for tracks
extension Event {

    @objc(addTracksObject:)
    @NSManaged func addToTracks(_ value: Track)

    @objc(removeTracksObject:)
    @NSManaged func removeFromTracks(_ value: Track)

    @objc(addTracks:)
    @NSManaged func addToTracks(_ values: Set<Track>)

    @objc(removeTracks:)
    @NSManaged func removeFromTracks(_ values: Set<Track>)

}
