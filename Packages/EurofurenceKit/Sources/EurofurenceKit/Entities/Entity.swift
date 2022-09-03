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
    
    class func fetchRequestForExistingEntity<E>(identifier: String) -> NSFetchRequest<E> where E: Entity {
        let entityDescription = E.entity()
        guard let entityName = entityDescription.name else {
            fatalError("Could not resolve name for \(E.self) from NSEntityDescription")
        }
        
        let fetchRequest: NSFetchRequest<E> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        return fetchRequest
    }
    
    class func entity(identifiedBy identifier: String, in managedObjectContext: NSManagedObjectContext) throws -> Self {
        let fetchRequest: NSFetchRequest<Self> = fetchRequestForExistingEntity(identifier: identifier)
        
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
