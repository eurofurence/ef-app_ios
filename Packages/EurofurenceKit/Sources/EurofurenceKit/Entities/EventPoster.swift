import CoreData

@objc(EventPoster)
public class EventPoster: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<EventPoster> {
        return NSFetchRequest<EventPoster>(entityName: "EventPoster")
    }

    @NSManaged public var events: Set<Event>

}

// MARK: Generated accessors for events
extension EventPoster {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
