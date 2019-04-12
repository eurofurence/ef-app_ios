@testable import Eurofurence
import EurofurenceModel
import UIKit

class CollectThemAllPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingCollectThemAllScene
        var service: FakeCollectThemAllService
    }

    func build() -> Context {
        let sceneFactory = StubCollectThemAllSceneFactory()
        let service = FakeCollectThemAllService()
        let module = CollectThemAllModuleBuilder()
            .with(sceneFactory)
            .with(service)
            .build()
            .makeCollectThemAllModule()

        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       service: service)
    }

}

extension CollectThemAllPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.collectThemAllSceneDidLoad()
    }

}
