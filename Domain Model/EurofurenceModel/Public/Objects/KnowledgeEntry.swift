import Foundation

public typealias KnowledgeEntryIdentifier = Identifier<KnowledgeEntry>

public protocol KnowledgeEntry {

    var identifier: KnowledgeEntryIdentifier { get }
    var title: String { get }
    var order: Int { get }
    var contents: String { get }
    var links: [Link] { get }
    
    func makeContentURL() -> URL

}
