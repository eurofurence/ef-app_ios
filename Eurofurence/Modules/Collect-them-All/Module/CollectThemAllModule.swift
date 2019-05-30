import EurofurenceModel
import UIKit

struct CollectThemAllModule: CollectThemAllModuleProviding {

    var sceneFactory: CollectThemAllSceneFactory
    var service: CollectThemAllService
    var interactionRecorder: CollectThemAllInteractionRecorder

    func makeCollectThemAllModule() -> UIViewController {
        let scene = sceneFactory.makeCollectThemAllScene()
        scene.setShortCollectThemAllTitle(.collect)
        scene.setCollectThemAllTitle(.collectThemAll)
        _ = CollectThemAllPresenter(scene: scene, service: service, interactionRecorder: interactionRecorder)

        return scene
    }

}
