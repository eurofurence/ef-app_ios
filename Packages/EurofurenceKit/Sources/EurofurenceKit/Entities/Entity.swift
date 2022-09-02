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
        let entityDescription: NSEntityDescription = Self.entity()
        guard let entityName = entityDescription.name else {
            fatalError("Entity \(String(describing: Self.self)) does not possess a name in its NSEntityDescription!")
        }
        
        let fetchRequest: NSFetchRequest<Self> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let fetchResults: [Self] = try managedObjectContext.fetch(fetchRequest)
        if let existingEntity = fetchResults.first {
            return existingEntity
        } else {
            let newEntity = Self(context: managedObjectContext)
            newEntity.identifier = identifier
            
            return newEntity
        }
    }
    
}
