import CoreData

@objc(Track)
public class Track: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String
    @NSManaged public var events: NSSet

}

// MARK: Generated accessors for events
extension Track {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: NSSet)

}

