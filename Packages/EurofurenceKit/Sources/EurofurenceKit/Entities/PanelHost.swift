import CoreData

@objc(PanelHost)
public class PanelHost: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<PanelHost> {
        return NSFetchRequest<PanelHost>(entityName: "PanelHost")
    }

    @NSManaged public var name: String
    @NSManaged public var hostingEvents: Set<Event>

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

