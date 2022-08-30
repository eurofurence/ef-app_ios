import CoreData

@objc(MapEntry)
public class MapEntry: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<MapEntry> {
        return NSFetchRequest<MapEntry>(entityName: "MapEntry")
    }

    @NSManaged public var identifier: String
    @NSManaged public var radius: Int32
    @NSManaged public var x: Int32
    @NSManaged public var y: Int32
    @NSManaged public var links: NSSet
    @NSManaged public var map: Map

}

// MARK: Generated accessors for links
extension MapEntry {

    @objc(addLinksObject:)
    @NSManaged func addToLinks(_ value: MapEntryLink)

    @objc(removeLinksObject:)
    @NSManaged func removeFromLinks(_ value: MapEntryLink)

    @objc(addLinks:)
    @NSManaged func addToLinks(_ values: NSSet)

    @objc(removeLinks:)
    @NSManaged func removeFromLinks(_ values: NSSet)

}
