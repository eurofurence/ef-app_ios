import EurofurenceModel
import UIKit

struct CollectThemAllComponentFactoryImpl: CollectThemAllComponentFactory {

    var sceneFactory: HybridWebSceneFactory
    var service: CollectThemAllService

    func makeCollectThemAllComponent() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        _ = CollectThemAllPresenter(scene: scene, service: service)

        return scene
    }

}
