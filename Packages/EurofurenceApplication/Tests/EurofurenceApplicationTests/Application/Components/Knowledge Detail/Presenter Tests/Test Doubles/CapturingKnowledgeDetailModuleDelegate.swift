import EurofurenceApplication
import EurofurenceModel
import XCTEurofurenceModel

class CapturingKnowledgeDetailComponentDelegate: KnowledgeDetailComponentDelegate {

    private(set) var capturedLinkToOpen: Link?
    func knowledgeComponentModuleDidSelectLink(_ link: Link) {
        capturedLinkToOpen = link
    }

}
