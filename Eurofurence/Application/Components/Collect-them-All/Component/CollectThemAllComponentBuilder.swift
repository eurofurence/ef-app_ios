import EurofurenceModel
import UIKit

class CollectThemAllComponentBuilder {

    private var sceneFactory: HybridWebSceneFactory
    private let service: CollectThemAllService

    init(service: CollectThemAllService) {
        self.service = service
        sceneFactory = StoryboardHybridWebSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: HybridWebSceneFactory) -> CollectThemAllComponentBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> CollectThemAllComponentFactory {
        CollectThemAllComponentFactoryImpl(sceneFactory: sceneFactory, service: service)
    }

}
