import UIKit.UIApplication

class PreloadComponentBuilder {

    private let preloadInteractor: PreloadInteractor
    private let alertRouter: AlertRouter
    private var preloadSceneFactory: PreloadSceneFactory

    init(preloadInteractor: PreloadInteractor, alertRouter: AlertRouter) {
        self.preloadInteractor = preloadInteractor
        self.alertRouter = alertRouter
        
        preloadSceneFactory = StoryboardPreloadSceneFactory()
    }

    func with(_ preloadSceneFactory: PreloadSceneFactory) -> Self {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    func build() -> PreloadComponentFactory {
        PreloadComponentFactoryImpl(
            preloadSceneFactory: preloadSceneFactory,
            preloadService: preloadInteractor,
            alertRouter: alertRouter
        )
    }

}
