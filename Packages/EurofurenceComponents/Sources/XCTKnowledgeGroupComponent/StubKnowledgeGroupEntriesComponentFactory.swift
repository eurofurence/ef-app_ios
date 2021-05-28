import EurofurenceModel
import KnowledgeGroupComponent
import UIKit

public class StubKnowledgeGroupEntriesComponentFactory: KnowledgeGroupEntriesComponentFactory {
    
    public init() {
        
    }

    public let stubInterface = UIViewController()
    public private(set) var delegate: KnowledgeGroupEntriesComponentDelegate?
    public private(set) var capturedModel: KnowledgeGroupIdentifier?
    public func makeKnowledgeGroupEntriesModule(
        _ groupIdentifier: KnowledgeGroupIdentifier,
        delegate: KnowledgeGroupEntriesComponentDelegate
    ) -> UIViewController {
        capturedModel = groupIdentifier
        self.delegate = delegate
        return stubInterface
    }

}

extension StubKnowledgeGroupEntriesComponentFactory {

    public func simulateKnowledgeEntrySelected(_ entry: KnowledgeEntryIdentifier) {
        delegate?.knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: entry)
    }

}
