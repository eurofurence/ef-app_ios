import CoreData

@objc(Day)
public class Day: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var events: Set<Event>

}

// MARK: - Day + ConsumesRemoteResponse

extension Day: ConsumesRemoteResponse {
    
    typealias RemoteResponse = RemoteDay
    
    func update(from remoteResponse: RemoteDay) {
        identifier = remoteResponse.Id
        lastEdited = remoteResponse.LastChangeDateTimeUtc
        date = remoteResponse.Date
        name = remoteResponse.Name
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
