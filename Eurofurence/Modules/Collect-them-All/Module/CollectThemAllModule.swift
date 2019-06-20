import EurofurenceModel
import UIKit

struct CollectThemAllModule: CollectThemAllModuleProviding {

    var sceneFactory: HybridWebSceneFactory
    var service: CollectThemAllService

    func makeCollectThemAllModule() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        _ = CollectThemAllPresenter(scene: scene, service: service)

        return scene
    }

}
