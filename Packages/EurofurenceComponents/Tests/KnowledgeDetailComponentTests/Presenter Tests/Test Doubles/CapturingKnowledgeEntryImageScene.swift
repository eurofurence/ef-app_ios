import EurofurenceModel
import Foundation
import KnowledgeDetailComponent

class CapturingKnowledgeEntryImageScene: KnowledgeEntryImageScene {

    private(set) var capturedImagePNGData: Data?
    func showImagePNGData(_ data: Data) {
        capturedImagePNGData = data
    }

}
