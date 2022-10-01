import CoreData

@objc(MapEntryLink)
class MapEntryLink: Link {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<MapEntryLink> {
        return NSFetchRequest<MapEntryLink>(entityName: "MapEntryLink")
    }

    @NSManaged var mapEntry: MapEntry

}
