import CoreData

@objc(Track)
public class Track: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String
    @NSManaged public var events: Set<Event>

}

// MARK: - Track + ConsumesRemoteResponse

extension Track: ConsumesRemoteResponse {
    
    typealias RemoteObject = RemoteTrack
    
    func update(context: RemoteResponseConsumingContext<RemoteTrack>) throws {
        identifier = context.remoteObject.Id
        lastEdited = context.remoteObject.LastChangeDateTimeUtc
        name = context.remoteObject.Name
    }
    
}

// MARK: Generated accessors for events
extension Track {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: Set<Event>)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: Set<Event>)

}

