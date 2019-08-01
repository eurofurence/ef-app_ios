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
