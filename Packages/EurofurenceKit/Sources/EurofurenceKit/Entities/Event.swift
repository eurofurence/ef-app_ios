import CoreData
import EurofurenceWebAPI

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

// MARK: - Tags

extension Event {
    
    /// The collection of well-known tags associated with this event.
    public var canonicalTags: CanonicalTag {
        var tags = CanonicalTag()
        for tag in self.tags {
            tags.insert(tag.canonicalTag)
        }
        
        return tags
    }
    
}

// MARK: - Event + ConsumesRemoteResponse

extension Event: ConsumesRemoteResponse {
    
    typealias RemoteObject = RemoteEvent
    
    func update(context: RemoteResponseConsumingContext<RemoteEvent>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        slug = context.remoteObject.slug
        title = context.remoteObject.title
        subtitle = context.remoteObject.subtitle
        abstract = context.remoteObject.abstract
        deviatingFromConbook = context.remoteObject.isDeviatingFromConBook
        acceptingFeedback = context.remoteObject.isAcceptingFeedback
        eventDescription = context.remoteObject.description
        startDate = context.remoteObject.startDateTimeUtc
        endDate = context.remoteObject.endDateTimeUtc
        
        day = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.dayIdentifier)
        room = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.roomIdentifier)
        
        let track: Track = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.trackIdentifier)
        addToTracks(track)
                
        updateTags(context)
        updateHosts(context)
        updateBanner(context)
        updatePoster(context)
    }
    
    private func updateTags(_ context: RemoteResponseConsumingContext<RemoteEvent>) {
        for remoteTag in context.remoteObject.tags {
            let tag = Tag.named(name: remoteTag, in: context.managedObjectContext)
            addToTags(tag)
        }
    }
    
    private func updateHosts(_ context: RemoteResponseConsumingContext<RemoteEvent>) {
        let hosts = context.remoteObject.panelHostsSeperatedByComma.components(separatedBy: ",")
        for host in hosts {
            let trimmedHost = host.trimmingCharacters(in: .whitespaces)
            let host = PanelHost.named(name: trimmedHost, in: context.managedObjectContext)
            addToPanelHosts(host)
        }
    }
    
    private func updateBanner(_ context: RemoteResponseConsumingContext<RemoteEvent>) {
        let bannerID = context.remoteObject.bannerImageIdentifier
        if let bannerID = bannerID, let remoteBanner = context.image(identifiedBy: bannerID) {
            let eventBanner = EventBanner.identifiedBy(identifier: bannerID, in: context.managedObjectContext)
            eventBanner.update(from: remoteBanner)
            
            banner = eventBanner
        }
    }
    
    private func updatePoster(_ context: RemoteResponseConsumingContext<RemoteEvent>) {
        let posterID = context.remoteObject.posterImageIdentifier
        if let posterID = posterID, let remotePoster = context.image(identifiedBy: posterID) {
            let eventPoster = EventPoster.identifiedBy(identifier: posterID, in: context.managedObjectContext)
            eventPoster.update(from: remotePoster)
            
            poster = eventPoster
        }
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
