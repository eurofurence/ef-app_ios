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
    
    public struct Coordinate {
        
        let x: Int
        let y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
    }
    
    public enum Entry {
        case dealer(Dealer)
    }
    
    public func entry(at coordinate: Coordinate) -> Entry? {
        let fetchRequest: NSFetchRequest<MapEntry> = MapEntry.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "x == %li", coordinate.x),
            NSPredicate(format: "y == %li", coordinate.y)
        ])
        
        do {
            guard let fetchedResults = try managedObjectContext?.fetch(fetchRequest) else {
                return nil
            }
            
            guard let entry = fetchedResults.first else { return nil }
            guard let link = entry.links.first else { return nil }
            guard let destination = link.destination else { return nil }
            
            switch destination {
            case .dealer(let dealer):
                return .dealer(dealer)
            }
        } catch {
            Self.logger.error(
                "Failed to fetch map entries for specific coordinate",
                metadata: [
                    "Map": .string(identifier),
                    "Coordinate": .string("x=\(coordinate.x) , y=\(coordinate.y)"),
                    "Error": .string(String(describing: error))
                ]
            )
            
            return nil
        }
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
