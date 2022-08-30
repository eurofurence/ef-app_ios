import CoreData

@objc(DealerCategory)
public class DealerCategory: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DealerCategory> {
        return NSFetchRequest<DealerCategory>(entityName: "DealerCategory")
    }

    @NSManaged public var name: String
    @NSManaged public var dealers: Set<Dealer>

}

// MARK: Generated accessors for dealers
extension DealerCategory {

    @objc(addDealersObject:)
    @NSManaged func addToDealers(_ value: Dealer)

    @objc(removeDealersObject:)
    @NSManaged func removeFromDealers(_ value: Dealer)

    @objc(addDealers:)
    @NSManaged func addToDealers(_ values: Set<Dealer>)

    @objc(removeDealers:)
    @NSManaged func removeFromDealers(_ values: Set<Dealer>)
    
}
