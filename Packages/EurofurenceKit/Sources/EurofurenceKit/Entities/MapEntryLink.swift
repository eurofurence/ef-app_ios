import CoreData

@objc(MapEntryLink)
public class MapEntryLink: Link {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<MapEntryLink> {
        return NSFetchRequest<MapEntryLink>(entityName: "MapEntryLink")
    }

    @NSManaged public var mapEntry: MapEntry

}
