import CoreData

@objc(Link)
public class Link: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Link> {
        return NSFetchRequest<Link>(entityName: "Link")
    }

    @NSManaged public var fragmentType: String
    @NSManaged public var name: String
    @NSManaged public var target: String

}
