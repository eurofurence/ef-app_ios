import PreloadComponent

class CapturingPreloadInteractor: PreloadInteractor {

    private(set) var didBeginPreloading = false
    private(set) var beginPreloadInvocationCount = 0
    private var delegate: PreloadInteractorDelegate?
    func beginPreloading(delegate: PreloadInteractorDelegate) {
        self.delegate = delegate
        didBeginPreloading = true
        beginPreloadInvocationCount += 1
    }

    func notifyFailedToPreload() {
        delegate?.preloadInteractorDidFailToPreload()
    }

    func notifySucceededPreload() {
        delegate?.preloadInteractorDidFinishPreloading()
    }
    
    func simulateOldAppError() {
        delegate?.preloadInteractorFailedToLoadDueToOldAppDetected()
    }

    func notifyProgressMade(current: Int, total: Int, localizedDescription: String) {
        delegate?.preloadInteractorDidProgress(
            currentUnitCount: current,
            totalUnitCount: total,
            localizedDescription: localizedDescription
        )
    }

}
