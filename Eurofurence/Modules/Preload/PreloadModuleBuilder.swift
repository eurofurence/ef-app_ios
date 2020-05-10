import UIKit.UIApplication

class PreloadModuleBuilder {

    private let preloadInteractor: PreloadInteractor
    private let alertRouter: AlertRouter
    private var preloadSceneFactory: PreloadSceneFactory

    init(preloadInteractor: PreloadInteractor, alertRouter: AlertRouter) {
        self.preloadInteractor = preloadInteractor
        self.alertRouter = alertRouter
        
        preloadSceneFactory = StoryboardPreloadSceneFactory()
    }

    func with(_ preloadSceneFactory: PreloadSceneFactory) -> PreloadModuleBuilder {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    func build() -> PreloadModuleProviding {
        return PreloadModule(preloadSceneFactory: preloadSceneFactory,
                             preloadService: preloadInteractor,
                             alertRouter: alertRouter)
    }

}
