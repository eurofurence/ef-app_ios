import Foundation

struct KnowledgeGroupImpl: KnowledgeGroup {
    
    var identifier: KnowledgeGroupIdentifier
    var title: String
    var groupDescription: String
    var fontAwesomeCharacterAddress: Character
    var order: Int
    var entries: [KnowledgeEntry]
    
}

extension KnowledgeGroupImpl {
    
    static func fromServerModels(groups: [KnowledgeGroupCharacteristics],
                                 entries: [KnowledgeEntryCharacteristics],
                                 shareableURLFactory: ShareableURLFactory) -> [KnowledgeGroup] {
        return groups.map({ (group) -> KnowledgeGroup in
            let entries = entries
                .filter({ $0.groupIdentifier == group.identifier })
                .map({ KnowledgeEntryImpl.fromServerModel($0, shareableURLFactory: shareableURLFactory) })
                .sorted(by: { (first, second) in
                    return first.order < second.order
                })
            
            let defaultFontAwesomeBackupCharacter: Character = " "
            let fontAwesomeCharacter: Character = Int(group.fontAwesomeCharacterAddress, radix: 16)
                .let(UnicodeScalar.init)
                .let(Character.init)
                .defaultingTo(defaultFontAwesomeBackupCharacter)
            
            return KnowledgeGroupImpl(
                identifier: KnowledgeGroupIdentifier(group.identifier),
                title: group.groupName,
                groupDescription: group.groupDescription,
                fontAwesomeCharacterAddress: fontAwesomeCharacter,
                order: group.order,
                entries: entries
            )
        }).sorted(by: { (first, second) in
            return first.order < second.order
        })
    }
    
}
