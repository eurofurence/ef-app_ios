import Eurofurence
import EurofurenceModel
import Foundation

class CapturingKnowledgeEntryImageScene: KnowledgeEntryImageScene {

    private(set) var capturedImagePNGData: Data?
    func showImagePNGData(_ data: Data) {
        capturedImagePNGData = data
    }

}
