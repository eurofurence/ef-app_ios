import CoreData

@objc(Room)
public class Room: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var name: String
    @NSManaged public var shortName: String
    @NSManaged public var events: Set<Event>

}

// MARK: - Room + ConsumesRemoteResponse

extension Room: ConsumesRemoteResponse {
    
    typealias RemoteResponse = RemoteRoom
    
    func update(from remoteResponse: RemoteRoom) {
        identifier = remoteResponse.Id
        lastEdited = remoteResponse.LastChangeDateTimeUtc
        name = remoteResponse.Name
        shortName = remoteResponse.ShortName
    }
    
}

// MARK: Generated accessors for events
extension Room {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: Set<Event>)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: Set<Event>)

}

