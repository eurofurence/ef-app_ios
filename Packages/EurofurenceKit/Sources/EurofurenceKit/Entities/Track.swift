import CoreData
import EurofurenceWebAPI

@objc(Track)
public class Track: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String
    @NSManaged public var events: Set<Event>

}

// MARK: - CanonicalTrack Adaptation

extension Track {
    
    public var canonicalTrack: CanonicalTrack {
        CanonicalTrack(trackName: name)
    }
    
}

// MARK: - Fetching

extension Track {
    
    /// Produces an `NSFetchRequest` for fetching all `Track` entities in alphabetical order.
    /// - Returns: An `NSFetchRequest` for fetching all `Track` entities in alphabetical order.
    public static func alphabeticallySortedFetchRequest() -> NSFetchRequest<Track> {
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Track.name, ascending: true)]
        
        return fetchRequest
    }
    
}

// MARK: - Track + ConsumesRemoteResponse

extension Track: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Track
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        name = context.remoteObject.name
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
