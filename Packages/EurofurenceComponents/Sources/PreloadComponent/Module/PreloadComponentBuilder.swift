import ComponentBase
import UIKit.UIApplication

public class PreloadComponentBuilder {

    private let preloadInteractor: PreloadInteractor
    private let alertRouter: AlertRouter
    private var preloadSceneFactory: PreloadSceneFactory

    public init(preloadInteractor: PreloadInteractor, alertRouter: AlertRouter) {
        self.preloadInteractor = preloadInteractor
        self.alertRouter = alertRouter
        
        preloadSceneFactory = StoryboardPreloadSceneFactory()
    }

    public func with(_ preloadSceneFactory: PreloadSceneFactory) -> Self {
        self.preloadSceneFactory = preloadSceneFactory
        return self
    }

    public func build() -> PreloadComponentFactory {
        PreloadComponentFactoryImpl(
            preloadSceneFactory: preloadSceneFactory,
            preloadService: preloadInteractor,
            alertRouter: alertRouter
        )
    }

}
