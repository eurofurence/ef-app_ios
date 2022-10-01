import CoreData
import EurofurenceWebAPI

@objc(MapEntry)
class MapEntry: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<MapEntry> {
        return NSFetchRequest<MapEntry>(entityName: "MapEntry")
    }

    @NSManaged var identifier: String
    @NSManaged var radius: Int32
    @NSManaged var x: Int32
    @NSManaged var y: Int32
    @NSManaged var links: Set<MapEntryLink>
    @NSManaged var map: Map
    
    func isWithinTappingRange(of coordinate: Map.Coordinate) -> Bool {
        distance(from: coordinate) <= Double(radius)
    }
    
    private func distance(from coordinate: Map.Coordinate) -> Double {
        let (dX, dY) = (coordinate.x - Int(x), coordinate.y - Int(y))
        return hypot(Double(abs(dX)), Double(abs(dY)))
    }
    
}

// MARK: - Fetching

extension MapEntry {
    
    class func entry(identifiedBy identifier: String, in managedObjectContext: NSManagedObjectContext) -> MapEntry {
        let fetchRequest: NSFetchRequest<MapEntry> = MapEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let fetchResults = try? managedObjectContext.fetch(fetchRequest)
        if let existingEntry = fetchResults?.first {
            return existingEntry
        } else {
            let newEntry = MapEntry(context: managedObjectContext)
            newEntry.identifier = identifier
            return newEntry
        }
    }
    
}

// MARK: - Updating

extension MapEntry {
    
    func update(from entry: EurofurenceWebAPI.Map.Entry, managedObjectContext: NSManagedObjectContext) {
        identifier = entry.id
        x = Int32(entry.x)
        y = Int32(entry.y)
        radius = Int32(entry.tapRadius)
        
        for link in entry.links {
            // Only insert this link if the entry does not contain an existing link.
            let containsLink = links.contains { entityLink in
                return entityLink.fragmentType == link.fragmentType &&
                entityLink.target == link.target &&
                entityLink.name == link.name
            }
            
            if containsLink {
                continue
            }
            
            let linkEntity = MapEntryLink(context: managedObjectContext)
            linkEntity.update(from: link)
            addToLinks(linkEntity)
        }
    }
    
}

// MARK: Generated accessors for links
extension MapEntry {

    @objc(addLinksObject:)
    @NSManaged func addToLinks(_ value: MapEntryLink)

    @objc(removeLinksObject:)
    @NSManaged func removeFromLinks(_ value: MapEntryLink)

    @objc(addLinks:)
    @NSManaged func addToLinks(_ values: Set<MapEntryLink>)

    @objc(removeLinks:)
    @NSManaged func removeFromLinks(_ values: Set<MapEntryLink>)

}
