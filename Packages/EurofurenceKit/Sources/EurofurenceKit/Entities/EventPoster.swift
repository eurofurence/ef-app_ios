import CoreData

@objc(EventPoster)
public class EventPoster: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<EventPoster> {
        return NSFetchRequest<EventPoster>(entityName: "EventPoster")
    }

    @NSManaged public var event: Event

}
