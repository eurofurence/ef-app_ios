import Eurofurence
import EurofurenceModel
import UIKit

class StubKnowledgeGroupEntriesModuleProviding: KnowledgeGroupEntriesModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: KnowledgeGroupEntriesModuleDelegate?
    private(set) var capturedModel: KnowledgeGroupIdentifier?
    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController {
        capturedModel = groupIdentifier
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupEntriesModuleProviding {

    func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntryIdentifier) {
        delegate?.knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: entry)
    }

}
