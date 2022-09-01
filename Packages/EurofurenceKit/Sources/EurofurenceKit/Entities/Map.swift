import CoreData
import EurofurenceWebAPI

@objc(Map)
public class Map: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var isBrowsable: Bool
    @NSManaged public var mapDescription: String
    @NSManaged public var order: Int16
    @NSManaged public var entries: Set<MapEntry>
    @NSManaged public var graphic: MapGraphic

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
        let graphic = try MapGraphic.entity(identifiedBy: context.remoteObject.imageIdentifier, in: context.managedObjectContext)
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
