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
    @NSManaged public var entries: Set<KnowledgeEntry>

}

// MARK: - KnowledgeGroup + ConsumesRemoteResponse

extension KnowledgeGroup: ConsumesRemoteResponse {
    
    typealias RemoteResponse = RemoteKnowledgeGroup
    
    func update(from remoteResponse: RemoteKnowledgeGroup) throws {
        identifier = remoteResponse.Id
        lastEdited = remoteResponse.LastChangeDateTimeUtc
        name = remoteResponse.Name
        knowledgeGroupDescription = remoteResponse.Description
        order = Int16(remoteResponse.Order)
        fontAwesomeUnicodeCharacterAddress = remoteResponse.FontAwesomeIconCharacterUnicodeAddress
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

