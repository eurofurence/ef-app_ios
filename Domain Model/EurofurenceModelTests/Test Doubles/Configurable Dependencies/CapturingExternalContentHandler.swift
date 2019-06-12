import EurofurenceModel
import Foundation

class CapturingExternalContentHandler: ExternalContentHandler {

    private(set) var capturedExternalContentURL: URL?
    func handleExternalContent(url: URL) {
        capturedExternalContentURL = url
    }

}
