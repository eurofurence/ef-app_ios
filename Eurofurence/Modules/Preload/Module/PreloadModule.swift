import UIKit

protocol PreloadModuleDelegate {

    func preloadModuleDidCancelPreloading()
    func preloadModuleDidFinishPreloading()

}

struct PreloadModule: PreloadModuleProviding {

    var preloadSceneFactory: PreloadSceneFactory
    var preloadService: PreloadInteractor
    var alertRouter: AlertRouter

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        let preloadScene = preloadSceneFactory.makePreloadScene()
        _ = PreloadPresenter(delegate: delegate,
                             preloadScene: preloadScene,
                             preloadService: preloadService,
                             alertRouter: alertRouter)

        return preloadScene
    }

}
