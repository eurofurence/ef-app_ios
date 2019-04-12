@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingKnowledgeDetailModuleDelegate: KnowledgeDetailModuleDelegate {

    private(set) var capturedLinkToOpen: Link?
    func knowledgeDetailModuleDidSelectLink(_ link: Link) {
        capturedLinkToOpen = link
    }

}
