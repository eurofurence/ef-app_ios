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
    @NSManaged public var order: Int16
    @NSManaged public var entries: Set<KnowledgeEntry>

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

