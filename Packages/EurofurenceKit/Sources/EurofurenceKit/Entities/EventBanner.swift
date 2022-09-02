import CoreData

@objc(EventBanner)
public class EventBanner: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<EventBanner> {
        return NSFetchRequest<EventBanner>(entityName: "EventBanner")
    }

    @NSManaged public var events: Set<Event>

}

// MARK: Generated accessors for events
extension EventBanner {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
