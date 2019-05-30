@testable import Eurofurence
import EurofurenceModel
import UIKit

class CollectThemAllPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingCollectThemAllScene
        var service: FakeCollectThemAllService
        var collectThemAllInteractionRecorder: CapturingCollectThemAllInteractionRecorder
    }

    func build() -> Context {
        let sceneFactory = StubCollectThemAllSceneFactory()
        let service = FakeCollectThemAllService()
        let interactionRecorder = CapturingCollectThemAllInteractionRecorder()
        let module = CollectThemAllModuleBuilder(service: service, interactionRecorder: interactionRecorder)
            .with(sceneFactory)
            .build()
            .makeCollectThemAllModule()

        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       service: service,
                       collectThemAllInteractionRecorder: interactionRecorder)
    }

}

extension CollectThemAllPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.collectThemAllSceneDidLoad()
    }

}
