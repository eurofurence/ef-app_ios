import CoreData

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
