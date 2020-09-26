import EurofurenceModel
import Foundation
import TestUtilities

public final class FakeKnowledgeEntry: KnowledgeEntry {
    
    public var identifier: KnowledgeEntryIdentifier
    public var title: String
    public var order: Int
    public var contents: String
    public var links: [Link]

    public init(
        identifier: KnowledgeEntryIdentifier,
        title: String,
        order: Int,
        contents: String,
        links: [Link]
    ) {
        self.identifier = identifier
        self.title = title
        self.order = order
        self.contents = contents
        self.links = links
    }
    
    public let contentURL: URL = .random
    
}

extension FakeKnowledgeEntry: RandomValueProviding {

    public static var random: FakeKnowledgeEntry {
        return FakeKnowledgeEntry(identifier: .random, title: .random, order: .random, contents: .random, links: .random)
    }

}
