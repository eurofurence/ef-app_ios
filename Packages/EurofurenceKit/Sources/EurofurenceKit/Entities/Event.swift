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
        identifier = context.remoteObject.Id
        lastEdited = context.remoteObject.LastChangeDateTimeUtc
        slug = context.remoteObject.Slug
        title = context.remoteObject.Title
        subtitle = context.remoteObject.SubTitle
        abstract = context.remoteObject.Abstract
        day = try managedObjectContext!.entity(withIdentifier: context.remoteObject.ConferenceDayId)
        
        let track: Track = try managedObjectContext!.entity(withIdentifier: context.remoteObject.ConferenceTrackId)
        addToTracks(track)
        
        room = try managedObjectContext!.entity(withIdentifier: context.remoteObject.ConferenceRoomId)
        eventDescription = context.remoteObject.Description
        startDate = context.remoteObject.StartDateTimeUtc
        endDate = context.remoteObject.EndDateTimeUtc
        
        let hosts = context.remoteObject.PanelHosts.components(separatedBy: ",")
        for host in hosts {
            let trimmedHost = host.trimmingCharacters(in: .whitespaces)
            let host = PanelHost.named(name: trimmedHost, in: managedObjectContext!)
            addToPanelHosts(host)
        }
        
        for remoteTag in context.remoteObject.Tags {
            let tag = Tag.named(name: remoteTag, in: managedObjectContext!)
            addToTags(tag)
        }
        
        deviatingFromConbook = context.remoteObject.IsDeviatingFromConBook
        acceptingFeedback = context.remoteObject.IsAcceptingFeedback
        
        if let bannerImageIdentifier = context.remoteObject.BannerImageId,
            let remoteBanner = context.response.images.changed.first(where: { $0.Id == bannerImageIdentifier }) {
            let eventBanner = EventBanner.identifiedBy(identifier: bannerImageIdentifier, in: managedObjectContext!)
            eventBanner.update(from: remoteBanner)
            banner = eventBanner
        }
        
        if let posterImageIdentifier = context.remoteObject.PosterImageId,
            let remotePoster = context.response.images.changed.first(where: { $0.Id == posterImageIdentifier }) {
            let eventPoster = EventPoster.identifiedBy(identifier: posterImageIdentifier, in: managedObjectContext!)
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
