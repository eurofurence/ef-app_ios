import CoreData

@objc(Entity)
public class Entity: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged var identifier: String
    @NSManaged var lastEdited: Date

}
