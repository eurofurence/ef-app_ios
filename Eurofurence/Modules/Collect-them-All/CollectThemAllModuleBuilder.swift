import EurofurenceModel
import UIKit

class CollectThemAllModuleBuilder {

    private var sceneFactory: CollectThemAllSceneFactory
    private let service: CollectThemAllService

    init(service: CollectThemAllService) {
        self.service = service
        sceneFactory = StoryboardCollectThemAllSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: CollectThemAllSceneFactory) -> CollectThemAllModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> CollectThemAllModuleProviding {
        return CollectThemAllModule(sceneFactory: sceneFactory, service: service)
    }

}
