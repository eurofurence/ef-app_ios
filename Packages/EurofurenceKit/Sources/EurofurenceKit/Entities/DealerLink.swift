import CoreData

@objc(DealerLink)
public class DealerLink: Link {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<DealerLink> {
        return NSFetchRequest<DealerLink>(entityName: "DealerLink")
    }

    @NSManaged public var dealer: Dealer

}
