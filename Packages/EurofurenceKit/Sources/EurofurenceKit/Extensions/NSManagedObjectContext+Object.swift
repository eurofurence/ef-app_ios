import CoreData

extension NSManagedObjectContext {
    
    struct NoSuchObject<Object>: Error {
        var predicate: NSPredicate
    }
    
    struct DuplicatedEntity<Object>: Error {
        var identifier: String
        var candidates: [Object]
    }
    
    func object<Object>(matching predicate: NSPredicate) throws -> Object where Object: NSManagedObject {
        let fetchRequest: NSFetchRequest<Object> = NSFetchRequest(entityName: Object.entity().name!)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let fetchResults = try fetch(fetchRequest)
        if let result = fetchResults.first {
            return result
        } else {
            throw NoSuchObject<Object>(predicate: predicate)
        }
    }
    
    func entity<E>(withIdentifier identifier: String) throws -> E where E: Entity {
        let fetchRequest: NSFetchRequest<E> = NSFetchRequest(entityName: Entity.entity().name!)
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.predicate = predicate
        
        let fetchResults = try fetch(fetchRequest)
        
        switch fetchResults.count {
        case 0:
            throw NoSuchObject<E>(predicate: predicate)
            
        case 1:
            return fetchResults[0]
            
        default:
            throw DuplicatedEntity(identifier: identifier, candidates: fetchResults)
        }
    }
    
}
