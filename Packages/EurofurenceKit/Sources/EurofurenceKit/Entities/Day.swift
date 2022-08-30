import CoreData

@objc(Day)
public class Day: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var events: NSSet

}

// MARK: Generated accessors for events
extension Day {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: NSSet)

}
