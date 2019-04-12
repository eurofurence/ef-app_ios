import EurofurenceModel
import Foundation

class CapturingCollectThemAllURLObserver: CollectThemAllURLObserver {

    private(set) var capturedURLRequest: URLRequest?
    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        capturedURLRequest = urlRequest
    }

}
