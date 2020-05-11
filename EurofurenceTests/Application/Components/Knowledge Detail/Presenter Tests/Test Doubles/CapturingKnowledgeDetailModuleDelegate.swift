import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingKnowledgeDetailComponentDelegate: KnowledgeDetailComponentDelegate {

    private(set) var capturedLinkToOpen: Link?
    func knowledgeComponentModuleDidSelectLink(_ link: Link) {
        capturedLinkToOpen = link
    }

}
