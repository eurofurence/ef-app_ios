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

extension KnowledgeEntry {
    
    func update(
        from remoteResponse: RemoteKnowledgeEntry,
        fullResponse: RemoteSyncResponse
    ) throws {
        for link in links {
            removeFromLinks(link)
            managedObjectContext!.delete(link)
        }
        
        identifier = remoteResponse.Id
        lastEdited = remoteResponse.LastChangeDateTimeUtc
        title = remoteResponse.Title
        text = remoteResponse.Text
        order = Int16(remoteResponse.Order)
        
        group = try managedObjectContext!.entity(withIdentifier: remoteResponse.KnowledgeGroupId)
        
        for imageIdentifier in remoteResponse.ImageIds {
            if let remoteImage = fullResponse.images.changed.first(where: { $0.Id == imageIdentifier }) {
                let image = KnowledgeEntryImage.identifiedBy(identifier: imageIdentifier, in: managedObjectContext!)
                image.update(from: remoteImage)
                addToImages(image)
            }
        }
        
        for link in remoteResponse.Links {
            let knowledgeLink = KnowledgeLink(context: managedObjectContext!)
            knowledgeLink.fragmentType = link.FragmentType
            knowledgeLink.name = link.Name
            knowledgeLink.target = link.Target
            addToLinks(knowledgeLink)
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
