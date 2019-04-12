@testable import Eurofurence
import EurofurenceModel

class CapturingLinkScene: LinkScene {

    private(set) var capturedLinkName: String?
    func setLinkName(_ linkName: String) {
        capturedLinkName = linkName
    }

}
