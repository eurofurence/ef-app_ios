import CoreData

@objc(MapGraphic)
public class MapGraphic: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<MapGraphic> {
        return NSFetchRequest<MapGraphic>(entityName: "MapGraphic")
    }

    @NSManaged public var map: Map

}
