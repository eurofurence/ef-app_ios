import EurofurenceModel
import KnowledgeDetailComponent
import UIKit.UIViewController
import XCTEurofurenceModel

public class StubKnowledgeDetailComponentFactory: KnowledgeDetailComponentFactory {
    
    public init() {
        
    }

    public let stubInterface = UIViewController()
    public private(set) var capturedModel: KnowledgeEntryIdentifier?
    public private(set) var delegate: KnowledgeDetailComponentDelegate?
    public func makeKnowledgeListComponent(
        _ knowledgeEntry: KnowledgeEntryIdentifier, 
        delegate: KnowledgeDetailComponentDelegate
    ) -> UIViewController {
        capturedModel = knowledgeEntry
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeDetailComponentFactory {

    public func simulateLinkSelected(_ link: Link) {
        delegate?.knowledgeComponentModuleDidSelectLink(link)
    }

}
