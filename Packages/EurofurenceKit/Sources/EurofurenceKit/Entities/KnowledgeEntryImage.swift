import CoreData

@objc(KnowledgeEntryImage)
public class KnowledgeEntryImage: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeEntryImage> {
        return NSFetchRequest<KnowledgeEntryImage>(entityName: "KnowledgeEntryImage")
    }

    @NSManaged public var entry: KnowledgeEntry

}
