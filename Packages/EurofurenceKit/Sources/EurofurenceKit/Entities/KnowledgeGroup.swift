import CoreData

@objc(KnowledgeGroup)
public class KnowledgeGroup: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeGroup> {
        return NSFetchRequest<KnowledgeGroup>(entityName: "KnowledgeGroup")
    }

    @NSManaged public var fontAwesomeUnicodeCharacterAddress: String
    @NSManaged public var knowledgeGroupDescription: String
    @NSManaged public var name: String
    @NSManaged public var order: Int16
    @NSManaged public var entries: NSSet

}

// MARK: Generated accessors for entries
extension KnowledgeGroup {

    @objc(addEntriesObject:)
    @NSManaged func addToEntries(_ value: KnowledgeEntry)

    @objc(removeEntriesObject:)
    @NSManaged func removeFromEntries(_ value: KnowledgeEntry)

    @objc(addEntries:)
    @NSManaged func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged func removeFromEntries(_ values: NSSet)

}

