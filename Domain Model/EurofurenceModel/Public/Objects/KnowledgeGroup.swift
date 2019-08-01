import Foundation

public typealias KnowledgeGroupIdentifier = Identifier<KnowledgeGroup>

public protocol KnowledgeGroup {

    var identifier: KnowledgeGroupIdentifier { get }
    var title: String { get }
    var groupDescription: String { get }
    var fontAwesomeCharacterAddress: Character { get }
    var order: Int { get }
    var entries: [KnowledgeEntry] { get }

}

struct KnowledgeGroupImpl: KnowledgeGroup {
    
    var identifier: KnowledgeGroupIdentifier
    var title: String
    var groupDescription: String
    var fontAwesomeCharacterAddress: Character
    var order: Int
    var entries: [KnowledgeEntry]
    
    public init(identifier: KnowledgeGroupIdentifier, title: String, groupDescription: String, fontAwesomeCharacterAddress: Character, order: Int, entries: [KnowledgeEntry]) {
        self.identifier = identifier
        self.title = title
        self.groupDescription = groupDescription
        self.fontAwesomeCharacterAddress = fontAwesomeCharacterAddress
        self.order = order
        self.entries = entries
    }
    
}

extension KnowledgeGroup {

    static func fromServerModels(groups: [KnowledgeGroupCharacteristics], entries: [KnowledgeEntryCharacteristics]) -> [KnowledgeGroup] {
        return groups.map({ (group) -> KnowledgeGroup in
            let entries = entries
                .filter({ $0.groupIdentifier == group.identifier })
                .map(KnowledgeEntry.fromServerModel)
                .sorted(by: { (first, second) in
                    return first.order < second.order
                })

            let defaultFontAwesomeBackupCharacter: Character = " "
            let fontAwesomeCharacter: Character = Int(group.fontAwesomeCharacterAddress, radix: 16)
                .let(UnicodeScalar.init)
                .let(Character.init)
                .defaultingTo(defaultFontAwesomeBackupCharacter)

            return KnowledgeGroupImpl(identifier: KnowledgeGroupIdentifier(group.identifier),
                                      title: group.groupName,
                                      groupDescription: group.groupDescription,
                                      fontAwesomeCharacterAddress: fontAwesomeCharacter,
                                      order: group.order,
                                      entries: entries)
        }).sorted(by: { (first, second) in
            return first.order < second.order
        })
    }

}
