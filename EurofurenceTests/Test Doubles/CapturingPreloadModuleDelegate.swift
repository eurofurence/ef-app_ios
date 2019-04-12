@testable import Eurofurence
import EurofurenceModel

class CapturingPreloadModuleDelegate: PreloadModuleDelegate {

    private(set) var notifiedPreloadCancelled = false
    func preloadModuleDidCancelPreloading() {
        notifiedPreloadCancelled = true
    }

    private(set) var notifiedPreloadFinished = false
    func preloadModuleDidFinishPreloading() {
        notifiedPreloadFinished = true
    }

}
