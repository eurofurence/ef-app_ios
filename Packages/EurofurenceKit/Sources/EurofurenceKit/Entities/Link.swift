import CoreData
import EurofurenceWebAPI

@objc(Link)
public class Link: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Link> {
        return NSFetchRequest<Link>(entityName: "Link")
    }

    @NSManaged public var fragmentType: String
    @NSManaged public var name: String?
    @NSManaged public var target: String

}

// MARK: - Content Resolution

extension Link {
    
    enum Destination {
        
        case dealer(Dealer)
        
        init?(dealer: String, managedObjectContext: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<Dealer> = Dealer.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", dealer)
            
            do {
                let fetchedResults = try managedObjectContext.fetch(fetchRequest)
                if let dealer = fetchedResults.first {
                    self = .dealer(dealer)
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        
    }
    
    var destination: Destination? {
        guard let managedObjectContext = managedObjectContext else { return nil }
        
        switch fragmentType.lowercased() {
        case "dealerdetail":
            return Destination(dealer: target, managedObjectContext: managedObjectContext)
            
        default:
            return nil
        }
    }
    
}

// MARK: - Link + Identifiable

extension Link: Identifiable {
    
    public var id: some Hashable {
        var hasher = Hasher()
        hasher.combine(fragmentType)
        hasher.combine(target)
        
        return hasher.finalize()
    }
    
}

// MARK: - Updating

extension Link {
    
    func update(from link: EurofurenceWebAPI.Link) {
        fragmentType = link.fragmentType
        name = link.name
        target = link.target
    }
    
}
