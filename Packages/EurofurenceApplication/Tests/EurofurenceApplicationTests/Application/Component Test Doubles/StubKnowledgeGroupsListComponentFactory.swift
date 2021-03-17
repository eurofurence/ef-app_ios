import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTEurofurenceModel

class StubKnowledgeGroupsListComponentFactory: KnowledgeGroupsListComponentFactory {

    let stubInterface = FakeViewController()
    private(set) var delegate: KnowledgeGroupsListComponentDelegate?
    func makeKnowledgeListComponent(_ delegate: KnowledgeGroupsListComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupsListComponentFactory {

    func simulateKnowledgeGroupSelected(_ group: KnowledgeGroupIdentifier) {
        delegate?.knowledgeListModuleDidSelectKnowledgeGroup(group)
    }
    
    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntryIdentifier) {
        delegate?.knowledgeListModuleDidSelectKnowledgeEntry(entry)
    }

}
