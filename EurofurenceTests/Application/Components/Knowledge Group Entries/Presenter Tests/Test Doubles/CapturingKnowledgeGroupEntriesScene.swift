import Eurofurence
import EurofurenceModel
import Foundation
import UIKit

class CapturingKnowledgeGroupEntriesScene: UIViewController, KnowledgeGroupEntriesScene {

    fileprivate var delegate: KnowledgeGroupEntriesSceneDelegate?
    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedTitle: String?
    func setKnowledgeGroupTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedNumberOfEntriesToBind: Int?
    private(set) var binder: KnowledgeGroupEntriesBinder?
    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder) {
        capturedNumberOfEntriesToBind = numberOfEntries
        self.binder = binder
    }

}

extension CapturingKnowledgeGroupEntriesScene {

    func simulateSceneDidLoad() {
        delegate?.knowledgeGroupEntriesSceneDidLoad()
    }

    func simulateSceneDidSelectEntry(at index: Int) {
        delegate?.knowledgeGroupEntriesSceneDidSelectEntry(at: index)
    }

}
