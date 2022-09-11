import CoreData
import EurofurenceWebAPI

@objc(Day)
public class Day: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var events: Set<Event>

}

// MARK: - Fetching

extension Day {
    
    /// Produces an `NSFetchRequest` for fetching all `Day` entities in their temporally-occurring order.
    /// - Returns: An `NSFetchRequest` that fetches all days in the model, ordered by their occurrance.
    public static func temporallyOrderedFetchRequest() -> NSFetchRequest<Day> {
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        
        return fetchRequest
    }
    
}

// MARK: - Day + ConsumesRemoteResponse

extension Day: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Day
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        date = context.remoteObject.date
        name = context.remoteObject.name
    }
    
}

// MARK: - Generated accessors for events

extension Day {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: Set<Event>)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: Set<Event>)

}
