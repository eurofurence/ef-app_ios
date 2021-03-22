import EurofurenceModel
import KnowledgeDetailComponent

class CapturingLinkScene: LinkScene {
    
    private var tapHandler: (() -> Void)?
    func setTapHandler(_ tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
    }

    private(set) var capturedLinkName: String?
    func setLinkName(_ linkName: String) {
        capturedLinkName = linkName
    }
    
    func simulateTapped() {
        tapHandler?()
    }

}
