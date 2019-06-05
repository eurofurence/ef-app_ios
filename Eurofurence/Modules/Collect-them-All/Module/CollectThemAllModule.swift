import EurofurenceModel
import UIKit

struct CollectThemAllModule: CollectThemAllModuleProviding {

    var sceneFactory: CollectThemAllSceneFactory
    var service: CollectThemAllService

    func makeCollectThemAllModule() -> UIViewController {
        let scene = sceneFactory.makeCollectThemAllScene()
        scene.setShortCollectThemAllTitle(.collect)
        scene.setCollectThemAllTitle(.collectThemAll)
        _ = CollectThemAllPresenter(scene: scene, service: service)

        return scene
    }

}
