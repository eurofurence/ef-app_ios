import ComponentBase
import Foundation

struct PreloadPresenter: SplashSceneDelegate, PreloadInteractorDelegate {

    private let delegate: PreloadComponentDelegate
    private let preloadScene: SplashScene
    private let preloadService: PreloadInteractor
    private let alertRouter: AlertRouter

    init(delegate: PreloadComponentDelegate,
         preloadScene: SplashScene,
         preloadService: PreloadInteractor,
         alertRouter: AlertRouter) {
        self.delegate = delegate
        self.preloadScene = preloadScene
        self.preloadService = preloadService
        self.alertRouter = alertRouter

        preloadScene.delegate = self
    }

    func splashSceneWillAppear(_ splashScene: SplashScene) {
        beginPreloading()
    }

    func preloadInteractorDidFailToPreload() {
        let tryAgainAction = AlertAction(title: .tryAgain, action: beginPreloading)
        let cancelAction = AlertAction(title: .cancel, action: notifyDelegatePreloadingCancelled)
        
        let downloadErrorTitle = NSLocalizedString(
            "downloadError",
            bundle: .module,
            comment: "Title for the alert when the download fails"
        )
        
        let preloadFailureMessage = NSLocalizedString(
            "preloadFailureMessage",
            bundle: .module,
            comment: "Description for the alert when the download fails"
        )
        
        let alert = Alert(
            title: downloadErrorTitle,
            message: preloadFailureMessage,
            actions: [tryAgainAction, cancelAction]
        )
        
        alertRouter.show(alert)
    }

    func preloadInteractorDidFinishPreloading() {
        delegate.preloadModuleDidFinishPreloading()
    }
    
    func preloadInteractorFailedToLoadDueToOldAppDetected() {
        preloadScene.showStaleAppAlert()
        delegate.preloadModuleDidCancelPreloading()
    }

    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String) {
        let fractionalProgress = Float(currentUnitCount) / Float(totalUnitCount)
        preloadScene.showProgress(fractionalProgress, progressDescription: localizedDescription)
    }

    private func beginPreloading() {
        preloadService.beginPreloading(delegate: self)
    }

    private func notifyDelegatePreloadingCancelled() {
        delegate.preloadModuleDidCancelPreloading()
    }

}
