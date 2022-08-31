import CoreData

@objc(Entity)
public class Entity: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged var identifier: String
    @NSManaged var lastEdited: Date

}

// MARK: - Fetching

extension Entity {
    
    class func entity(identifiedBy identifier: String, in managedObjectContext: NSManagedObjectContext) throws -> Self {
        let fetchRequest: NSFetchRequest<Self> = NSFetchRequest(entityName: Self.entity().name!)
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let fetchResults: [Self] = try managedObjectContext.fetch(fetchRequest)
        if let existingEntity = fetchResults.first {
            return existingEntity
        } else {
            let newEntity = Self.init(context: managedObjectContext)
            newEntity.identifier = identifier
            
            return newEntity
        }
    }
    
}
