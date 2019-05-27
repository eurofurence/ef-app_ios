import UIKit.UIApplication

class PreloadModuleBuilder {

    private var preloadSceneFactory: PreloadSceneFactory
    private let preloadInteractor: PreloadInteractor
    private var alertRouter: AlertRouter

    init(preloadInteractor: PreloadInteractor) {
        self.preloadInteractor = preloadInteractor
        preloadSceneFactory = StoryboardPreloadSceneFactory()
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ preloadSceneFactory: PreloadSceneFactory) -> PreloadModuleBuilder {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    func with(_ alertRouter: AlertRouter) -> PreloadModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func build() -> PreloadModuleProviding {
        return PreloadModule(preloadSceneFactory: preloadSceneFactory,
                             preloadService: preloadInteractor,
                             alertRouter: alertRouter)
    }

}
