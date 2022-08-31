import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String
    @NSManaged public var events: Set<Event>

}

// MARK: - Fetching

extension Tag {
    
    static func named(name: String, in managedObjectContext: NSManagedObjectContext) -> Tag {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        let results = try? managedObjectContext.fetch(fetchRequest)
    
        if let existingPanelHost = results?.first {
            return existingPanelHost
        } else {
            let panelHost = Tag(context: managedObjectContext)
            panelHost.name = name
            return panelHost
        }
    }
    
}

// MARK: Generated accessors for events
extension Tag {

    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: Set<Event>)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: Set<Event>)

}
