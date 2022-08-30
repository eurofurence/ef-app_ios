import CoreData

@objc(EventBanner)
public class EventBanner: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<EventBanner> {
        return NSFetchRequest<EventBanner>(entityName: "EventBanner")
    }

    @NSManaged public var event: Event

}
