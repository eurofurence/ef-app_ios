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
    @NSManaged public var images: Set<KnowledgeEntryImage>
    @NSManaged public var links: Set<KnowledgeLink>

}

// MARK: - KnowledgeEntry + ConsumesRemoteResponse

extension KnowledgeEntry: ConsumesRemoteResponse {
    
    typealias RemoteObject = RemoteKnowledgeEntry
    
    func update(context: RemoteResponseConsumingContext<RemoteKnowledgeEntry>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        title = context.remoteObject.title
        text = context.remoteObject.text
        order = Int16(context.remoteObject.order)
        
        group = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.knowledgeGroupIdentifier)
        
        updateImages(context)
        updateLinks(context)
    }
    
    private func updateImages(_ context: RemoteResponseConsumingContext<RemoteKnowledgeEntry>) {
        for imageID in context.remoteObject.imageIdentifiers {
            if let remoteImage = context.image(identifiedBy: imageID) {
                let image = KnowledgeEntryImage.identifiedBy(identifier: imageID, in: context.managedObjectContext)
                image.update(from: remoteImage)
                addToImages(image)
            }
        }
    }
    
    private func updateLinks(_ context: RemoteResponseConsumingContext<RemoteKnowledgeEntry>) {
        removeAllLinks(context)
        
        for link in context.remoteObject.links {
            let knowledgeLink = KnowledgeLink(context: context.managedObjectContext)
            knowledgeLink.fragmentType = link.fragmentType
            knowledgeLink.name = link.name
            knowledgeLink.target = link.target
            addToLinks(knowledgeLink)
        }
    }
    
    private func removeAllLinks(_ context: RemoteResponseConsumingContext<RemoteKnowledgeEntry>) {
        for link in links {
            removeFromLinks(link)
            context.managedObjectContext.delete(link)
        }
    }
    
}

// MARK: Generated accessors for images
extension KnowledgeEntry {

    @objc(addImagesObject:)
    @NSManaged func addToImages(_ value: KnowledgeEntryImage)

    @objc(removeImagesObject:)
    @NSManaged func removeFromImages(_ value: KnowledgeEntryImage)

    @objc(addImages:)
    @NSManaged func addToImages(_ values: Set<KnowledgeEntryImage>)

    @objc(removeImages:)
    @NSManaged func removeFromImages(_ values: Set<KnowledgeEntryImage>)

}

// MARK: Generated accessors for links
extension KnowledgeEntry {

    @objc(addLinksObject:)
    @NSManaged func addToLinks(_ value: KnowledgeLink)

    @objc(removeLinksObject:)
    @NSManaged func removeFromLinks(_ value: KnowledgeLink)

    @objc(addLinks:)
    @NSManaged func addToLinks(_ values: Set<KnowledgeLink>)

    @objc(removeLinks:)
    @NSManaged func removeFromLinks(_ values: Set<KnowledgeLink>)

}
