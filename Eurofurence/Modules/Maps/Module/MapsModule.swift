import UIKit

struct MapsModule: MapsModuleProviding {

    var sceneFactory: MapsSceneFactory
    var interactor: MapsInteractor

    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapsScene()
        _ = MapsPresenter(scene: scene, interactor: interactor, delegate: delegate)

        return scene
    }

}
