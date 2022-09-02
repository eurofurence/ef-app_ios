import CoreData

@objc(KnowledgeLink)
public class KnowledgeLink: Link {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<KnowledgeLink> {
        return NSFetchRequest<KnowledgeLink>(entityName: "KnowledgeLink")
    }

    @NSManaged public var entry: KnowledgeEntry

}
