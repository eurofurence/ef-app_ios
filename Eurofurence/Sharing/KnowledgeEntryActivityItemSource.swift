import EurofurenceModel
import UIKit

public class KnowledgeEntryActivityItemSource: NSObject {
    
    public var knowledgeEntry: KnowledgeEntry
    
    public init(knowledgeEntry: KnowledgeEntry) {
        self.knowledgeEntry = knowledgeEntry
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? KnowledgeEntryActivityItemSource else { return false }
        return knowledgeEntry.identifier == other.knowledgeEntry.identifier
    }
    
}

// MARK: - UIActivityItemSource

extension KnowledgeEntryActivityItemSource: UIActivityItemSource {
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        knowledgeEntry.makeContentURL()
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        knowledgeEntry.makeContentURL()
    }
    
}
