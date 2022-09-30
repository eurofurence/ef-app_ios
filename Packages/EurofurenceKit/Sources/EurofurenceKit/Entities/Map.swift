import CoreData
import EurofurenceWebAPI
import Logging

@objc(Map)
public class Map: Entity {
    
    private static let logger = Logger(label: "Map")

    @nonobjc class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var isBrowsable: Bool
    @NSManaged public var mapDescription: String
    @NSManaged public var order: Int16
    @NSManaged public var graphic: MapGraphic
    
    @NSManaged var entries: Set<MapEntry>

}

// MARK: - Content Lookup

extension Map {
    
    /// A location within the geometry of a `Map`.
    public struct Coordinate {
        
        let x: Int
        let y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
    }
    
    /// A content assignment against a `Map`, associated to a specific location.
    public enum Entry: Comparable, Equatable, Identifiable {
        public var id: some Hashable {
            switch self {
            case .dealer(let dealer):
                return dealer.id
            }
        }
        
        case dealer(Dealer)
    }
    
    /// Determines the entries present at a specified point on the map.
    /// - Parameter coordinate: The `Coordinate` of the map to resolve the entries for.
    /// - Returns: A collection of entries associated with the designated map coordinate.
    public func entries(at coordinate: Coordinate) -> [Entry] {
        var entriesInRange = [MapEntry]()
        for entry in entries where entry.isWithinTappingRange(of: coordinate) {
            entriesInRange.append(entry)
        }
        
        return entriesInRange
            .flatMap(\.links)
            .compactMap(\.destination)
            .map { destination in
                switch destination {
                case .dealer(let dealer):
                    return .dealer(dealer)
                }
            }
            .sorted()
    }
    
}

// MARK: - Map + ConsumesRemoteResponse

extension Map: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Map
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        guard let image = context.image(identifiedBy: context.remoteObject.imageIdentifier) else {
            throw MapMissingImage(
                mapIdentifier: context.remoteObject.id,
                imageIdentifier: context.remoteObject.imageIdentifier
            )
        }
        
        updateAttributes(context)
        try updateGraphic(context, image)
        updateEntries(context)
    }
    
    private func updateAttributes(_ context: RemoteResponseConsumingContext<Map.RemoteObject>) {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        mapDescription = context.remoteObject.description
        order = Int16(context.remoteObject.order)
        isBrowsable = context.remoteObject.isBrowseable
    }
    
    private func updateGraphic(
        _ context: RemoteResponseConsumingContext<Map.RemoteObject>,
        _ image: EurofurenceWebAPI.Image
    ) throws {
        let graphic = try MapGraphic.entity(
            identifiedBy: context.remoteObject.imageIdentifier,
            in: context.managedObjectContext
        )
        
        graphic.update(from: image)
        self.graphic = graphic
    }
    
    private func updateEntries(_ context: RemoteResponseConsumingContext<Map.RemoteObject>) {
        for entry in context.remoteObject.entries {
            let entryEntity = MapEntry.entry(identifiedBy: entry.id, in: context.managedObjectContext)
            entryEntity.update(from: entry, managedObjectContext: context.managedObjectContext)
            
            addToEntries(entryEntity)
        }
    }
    
    private struct MapMissingImage: Error {
        var mapIdentifier: String
        var imageIdentifier: String
    }
    
}

// MARK: Generated accessors for entries
extension Map {

    @objc(addEntriesObject:)
    @NSManaged func addToEntries(_ value: MapEntry)

    @objc(removeEntriesObject:)
    @NSManaged func removeFromEntries(_ value: MapEntry)

    @objc(addEntries:)
    @NSManaged func addToEntries(_ values: Set<MapEntry>)

    @objc(removeEntries:)
    @NSManaged func removeFromEntries(_ values: Set<MapEntry>)

}
