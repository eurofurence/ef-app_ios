import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubKnowledgeGroupEntriesComponentFactory: KnowledgeGroupEntriesComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: KnowledgeGroupEntriesComponentDelegate?
    private(set) var capturedModel: KnowledgeGroupIdentifier?
    func makeKnowledgeGroupEntriesModule(
        _ groupIdentifier: KnowledgeGroupIdentifier,
        delegate: KnowledgeGroupEntriesComponentDelegate
    ) -> UIViewController {
        capturedModel = groupIdentifier
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupEntriesComponentFactory {

    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntryIdentifier) {
        delegate?.knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: entry)
    }

}
