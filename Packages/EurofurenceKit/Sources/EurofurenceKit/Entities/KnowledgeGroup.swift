import CoreData
import EurofurenceWebAPI

@objc(KnowledgeGroup)
public class KnowledgeGroup: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<KnowledgeGroup> {
        return NSFetchRequest<KnowledgeGroup>(entityName: "KnowledgeGroup")
    }

    @NSManaged public var fontAwesomeUnicodeCharacterAddress: String
    @NSManaged public var knowledgeGroupDescription: String
    @NSManaged public var name: String
    @NSManaged var order: Int16
    @NSManaged var entries: NSOrderedSet
    
    public var orderedKnowledgeEntries: [KnowledgeEntry] {
        entries.array(of: KnowledgeEntry.self)
    }
    
    public override func willSave() {
        super.willSave()
        orderKnowledgeEntries()
    }
    
    private func orderKnowledgeEntries() {
        let orderedEntries = entries.array(of: KnowledgeEntry.self).sorted()
        
        // Avoid mutations to the object graph if the set is already sorted. This can cause the managed object context
        // to remain stuck in a dirty state forever, otherwise.
        if orderedEntries == self.orderedKnowledgeEntries {
            return
        }
        
        for entry in orderedEntries {
            removeFromEntries(entry)
        }
        
        for entry in orderedEntries {
            addToEntries(entry)
        }
    }

}

// MARK: - Fetching

extension KnowledgeGroup {
    
    /// Produces an `NSFetchRequest` for fetching all `KnowledgeGroup`s, ordered by the characteristics of the model.
    /// - Returns: An `NSFetchRequest` for fetching all `KnowledgeGroup`s in their designated order.
    public static func orderedGroupsFetchRequest() -> NSFetchRequest<KnowledgeGroup> {
        let fetchRequest: NSFetchRequest<KnowledgeGroup> = KnowledgeGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \KnowledgeGroup.order, ascending: true)]
        
        return fetchRequest
    }
    
}

// MARK: - KnowledgeGroup + ConsumesRemoteResponse

extension KnowledgeGroup: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.KnowledgeGroup
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        name = context.remoteObject.name
        knowledgeGroupDescription = context.remoteObject.description
        order = Int16(context.remoteObject.order)
        fontAwesomeUnicodeCharacterAddress = context.remoteObject.fontAwesomeIconCharacterUnicodeAddress
    }
    
}

// MARK: Generated accessors for entries
extension KnowledgeGroup {

    @objc(addEntriesObject:)
    @NSManaged func addToEntries(_ value: KnowledgeEntry)

    @objc(removeEntriesObject:)
    @NSManaged func removeFromEntries(_ value: KnowledgeEntry)

    @objc(addEntries:)
    @NSManaged func addToEntries(_ values: Set<KnowledgeEntry>)

    @objc(removeEntries:)
    @NSManaged func removeFromEntries(_ values: Set<KnowledgeEntry>)

}
