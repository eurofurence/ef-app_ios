import EurofurenceModel
import UIKit

public struct KnowledgeEntryActivityItemSource: Equatable {
    
    public static func == (lhs: KnowledgeEntryActivityItemSource, rhs: KnowledgeEntryActivityItemSource) -> Bool {
        lhs.knowledgeEntry.identifier == rhs.knowledgeEntry.identifier
    }
    
    public var knowledgeEntry: KnowledgeEntry
    
    public init(knowledgeEntry: KnowledgeEntry) {
        self.knowledgeEntry = knowledgeEntry
    }
    
}
