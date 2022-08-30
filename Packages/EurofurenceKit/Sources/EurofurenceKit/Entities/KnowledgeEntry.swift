import CoreData

@objc(KnowledgeEntry)
public class KnowledgeEntry: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeEntry> {
        return NSFetchRequest<KnowledgeEntry>(entityName: "KnowledgeEntry")
    }

    @NSManaged public var order: Int16
    @NSManaged public var text: String
    @NSManaged public var title: String
    @NSManaged public var group: KnowledgeGroup
    @NSManaged public var images: NSSet
    @NSManaged public var links: NSSet

}

// MARK: Generated accessors for images
extension KnowledgeEntry {

    @objc(addImagesObject:)
    @NSManaged func addToImages(_ value: KnowledgeEntryImage)

    @objc(removeImagesObject:)
    @NSManaged func removeFromImages(_ value: KnowledgeEntryImage)

    @objc(addImages:)
    @NSManaged func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for links
extension KnowledgeEntry {

    @objc(addLinksObject:)
    @NSManaged func addToLinks(_ value: KnowledgeLink)

    @objc(removeLinksObject:)
    @NSManaged func removeFromLinks(_ value: KnowledgeLink)

    @objc(addLinks:)
    @NSManaged func addToLinks(_ values: NSSet)

    @objc(removeLinks:)
    @NSManaged func removeFromLinks(_ values: NSSet)

}
