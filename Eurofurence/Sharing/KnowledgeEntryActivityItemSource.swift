import EurofurenceModel
import UIKit

public class KnowledgeEntryActivityItemSource: URLBasedActivityItem {
    
    public var knowledgeEntry: KnowledgeEntry
    
    public init(knowledgeEntry: KnowledgeEntry) {
        self.knowledgeEntry = knowledgeEntry
        super.init(url: knowledgeEntry.makeContentURL())
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? KnowledgeEntryActivityItemSource else { return false }
        return knowledgeEntry.identifier == other.knowledgeEntry.identifier
    }
    
}
