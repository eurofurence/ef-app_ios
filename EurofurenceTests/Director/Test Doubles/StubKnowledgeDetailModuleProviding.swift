@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubKnowledgeDetailComponentFactory: KnowledgeDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: KnowledgeEntryIdentifier?
    private(set) var delegate: KnowledgeDetailComponentDelegate?
    func makeKnowledgeListModule(_ knowledgeEntry: KnowledgeEntryIdentifier, delegate: KnowledgeDetailComponentDelegate) -> UIViewController {
        capturedModel = knowledgeEntry
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeDetailComponentFactory {

    func simulateLinkSelected(_ link: Link) {
        delegate?.knowledgeComponentModuleDidSelectLink(link)
    }

}
