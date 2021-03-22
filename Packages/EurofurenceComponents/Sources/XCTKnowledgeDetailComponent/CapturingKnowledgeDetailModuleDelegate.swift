import EurofurenceModel
import KnowledgeDetailComponent

public class CapturingKnowledgeDetailComponentDelegate: KnowledgeDetailComponentDelegate {
    
    public init() {
        
    }

    public private(set) var capturedLinkToOpen: Link?
    public func knowledgeComponentModuleDidSelectLink(_ link: Link) {
        capturedLinkToOpen = link
    }

}
