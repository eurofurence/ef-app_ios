import CoreData

extension NSManagedObjectContext {

    func makeEntity<Entity>(uniquelyIdentifiedBy predicate: NSPredicate) -> Entity where Entity: NSManagedObject {
        let fetchRequest = Entity.fetchRequest() as? NSFetchRequest<Entity>
        fetchRequest?.fetchLimit = 1
        fetchRequest?.predicate = predicate

        let entity: Entity
        do {
            let results = try fetchRequest?.execute()
            if let result = results?.first {
                entity = result
            } else {
                entity = Entity(context: self)
            }
        } catch {
            entity = Entity(context: self)
        }

        return entity
    }

    func deleteFirstMatch<T>(for fetchRequest: NSFetchRequest<T>) where T: NSManagedObject {
        do {
            let results = try fetchRequest.execute()
            if let result = results.first {
                delete(result)
            }
        } catch {
            print(error)
        }
    }

}
