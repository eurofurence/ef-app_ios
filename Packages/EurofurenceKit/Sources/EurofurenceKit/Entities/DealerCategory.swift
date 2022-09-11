import CoreData

@objc(DealerCategory)
public class DealerCategory: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DealerCategory> {
        return NSFetchRequest<DealerCategory>(entityName: "DealerCategory")
    }

    @NSManaged public var name: String
    @NSManaged public var dealers: Set<Dealer>

}

// MARK: - DealerCategory + Identifiable

extension DealerCategory: Identifiable {
    
    public var id: some Hashable {
        objectID
    }
    
}

// MARK: - CanonicalCategory Adaptation

extension DealerCategory {
    
    public var canonicalCategory: CanonicalDealerCategory {
        CanonicalDealerCategory(categoryName: name)
    }
    
}

// MARK: - Fetching

extension DealerCategory {
    
    /// Produces an `NSFetchRequest` for displaying all categories, sorted in alphabetical order.
    /// - Returns: An `NSFetchRequest` that fetches all `DealerCategory` entities, sorted alphabetically by name.
    public static func alphabeticallySortedFetchRequest() -> NSFetchRequest<DealerCategory> {
        let fetchRequest: NSFetchRequest<DealerCategory> = DealerCategory.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DealerCategory.name, ascending: true)]
        
        return fetchRequest
    }
    
    static func named(name: String, in managedObjectContext: NSManagedObjectContext) -> DealerCategory {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        let results = try? managedObjectContext.fetch(fetchRequest)
    
        if let existingCategory = results?.first {
            return existingCategory
        } else {
            let category = DealerCategory(context: managedObjectContext)
            category.name = name
            return category
        }
    }
    
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
