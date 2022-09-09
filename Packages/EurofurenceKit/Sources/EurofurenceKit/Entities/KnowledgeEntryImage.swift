import CoreData

@objc(KnowledgeEntryImage)
public class KnowledgeEntryImage: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeEntryImage> {
        return NSFetchRequest<KnowledgeEntryImage>(entityName: "KnowledgeEntryImage")
    }

    @NSManaged public var entries: Set<KnowledgeEntry>

}

// MARK: - Predicates

extension KnowledgeEntryImage {
    
    /// Produces a predicate for use in an `NSFetchRequest` that will produce the images associated with a
    /// specified `KnowledgeEntry`
    ///
    /// - Parameter entry: A `KnowledgeEntry` from the model to fetch the associated images for.
    /// - Returns: An `NSPredicate` for fetching only the images of the associated knowledge entry.
    public static func predicateForImages(in entry: KnowledgeEntry) -> NSPredicate {
        NSPredicate(format: "%@ IN SELF.entries", entry)
    }
    
}

// MARK: Generated accessors for entries
extension KnowledgeEntryImage {

    @objc(addEntriesObject:)
    @NSManaged func addToEntries(_ value: KnowledgeEntry)

    @objc(removeEntriesObject:)
    @NSManaged func removeFromEntries(_ value: KnowledgeEntry)

    @objc(addEntries:)
    @NSManaged func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged func removeFromEntries(_ values: NSSet)

}
