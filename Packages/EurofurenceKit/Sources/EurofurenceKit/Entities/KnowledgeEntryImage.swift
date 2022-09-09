import CoreData

@objc(KnowledgeEntryImage)
public class KnowledgeEntryImage: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeEntryImage> {
        return NSFetchRequest<KnowledgeEntryImage>(entityName: "KnowledgeEntryImage")
    }

    @NSManaged public var entries: Set<KnowledgeEntry>

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
