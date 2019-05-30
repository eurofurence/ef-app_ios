import EurofurenceModel
import UIKit

class CollectThemAllModuleBuilder {

    private var sceneFactory: CollectThemAllSceneFactory
    private let service: CollectThemAllService
    private let interactionRecorder: CollectThemAllInteractionRecorder

    init(service: CollectThemAllService, interactionRecorder: CollectThemAllInteractionRecorder) {
        self.service = service
        self.interactionRecorder = interactionRecorder
        
        sceneFactory = StoryboardCollectThemAllSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: CollectThemAllSceneFactory) -> CollectThemAllModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> CollectThemAllModuleProviding {
        return CollectThemAllModule(sceneFactory: sceneFactory, service: service, interactionRecorder: interactionRecorder)
    }

}
