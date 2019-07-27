import Foundation

protocol PreloadInteractor {

    func beginPreloading(delegate: PreloadInteractorDelegate)

}

protocol PreloadInteractorDelegate {

    func preloadInteractorDidFailToPreload()
    func preloadInteractorDidFinishPreloading()
    func preloadInteractorFailedToLoadDueToOldAppDetected()
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String)

}
