import UIKit

public protocol PreloadComponentDelegate {

    func preloadModuleDidCancelPreloading()
    func preloadModuleDidFinishPreloading()

}

struct PreloadComponentFactoryImpl: PreloadComponentFactory {

    var preloadSceneFactory: PreloadSceneFactory
    var preloadService: PreloadInteractor
    var alertRouter: AlertRouter

    func makePreloadComponent(_ delegate: PreloadComponentDelegate) -> UIViewController {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(
            delegate: delegate,
            preloadScene: preloadScene,
            preloadService: preloadService,
            alertRouter: alertRouter
        )

        return preloadScene
    }

}
