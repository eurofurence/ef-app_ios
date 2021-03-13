import Foundation

public protocol PreloadInteractor {

    func beginPreloading(delegate: PreloadInteractorDelegate)

}

public protocol PreloadInteractorDelegate {

    func preloadInteractorDidFailToPreload()
    func preloadInteractorDidFinishPreloading()
    func preloadInteractorFailedToLoadDueToOldAppDetected()
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String)

}
