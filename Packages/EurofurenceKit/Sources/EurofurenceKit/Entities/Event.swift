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
    @NSManaged public var panelHosts: NSSet
    @NSManaged public var poster: EventPoster?
    @NSManaged public var room: Room
    @NSManaged public var tracks: NSSet

}

// MARK: Generated accessors for panelHosts
extension Event {

    @objc(addPanelHostsObject:)
    @NSManaged func addToPanelHosts(_ value: PanelHost)

    @objc(removePanelHostsObject:)
    @NSManaged func removeFromPanelHosts(_ value: PanelHost)

    @objc(addPanelHosts:)
    @NSManaged func addToPanelHosts(_ values: NSSet)

    @objc(removePanelHosts:)
    @NSManaged func removeFromPanelHosts(_ values: NSSet)

}

// MARK: Generated accessors for tracks
extension Event {

    @objc(addTracksObject:)
    @NSManaged func addToTracks(_ value: Track)

    @objc(removeTracksObject:)
    @NSManaged func removeFromTracks(_ value: Track)

    @objc(addTracks:)
    @NSManaged func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged func removeFromTracks(_ values: NSSet)

}
