import CoreData

@objc(PanelHost)
public class PanelHost: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<PanelHost> {
        return NSFetchRequest<PanelHost>(entityName: "PanelHost")
    }

    @NSManaged public var name: String
    @NSManaged public var hostingEvents: Set<Event>

}

// MARK: - Fetching

extension PanelHost {
    
    static func named(name: String, in managedObjectContext: NSManagedObjectContext) -> PanelHost {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        let results = try? managedObjectContext.fetch(fetchRequest)
    
        if let existingPanelHost = results?.first {
            return existingPanelHost
        } else {
            let panelHost = PanelHost(context: managedObjectContext)
            panelHost.name = name
            return panelHost
        }
    }
    
}

// MARK: Generated accessors for hostingEvents
extension PanelHost {

    @objc(addHostingEventsObject:)
    @NSManaged func addToHostingEvents(_ value: Event)

    @objc(removeHostingEventsObject:)
    @NSManaged func removeFromHostingEvents(_ value: Event)

    @objc(addHostingEvents:)
    @NSManaged func addToHostingEvents(_ values: Set<Event>)

    @objc(removeHostingEvents:)
    @NSManaged func removeFromHostingEvents(_ values: Set<Event>)

}

