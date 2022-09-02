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

// MARK: - Updating

extension Link {
    
    func update(from link: EurofurenceWebAPI.Link) {
        fragmentType = link.fragmentType
        name = link.name
        target = link.target
    }
    
}
