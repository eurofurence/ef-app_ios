import EurofurenceModel
import UIKit

class CollectThemAllModuleBuilder {

    private var sceneFactory: HybridWebSceneFactory
    private let service: CollectThemAllService

    init(service: CollectThemAllService) {
        self.service = service
        sceneFactory = StoryboardHybridWebSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: HybridWebSceneFactory) -> CollectThemAllModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> CollectThemAllModuleProviding {
        return CollectThemAllModule(sceneFactory: sceneFactory, service: service)
    }

}
