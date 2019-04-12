import EurofurenceModel
import UIKit

struct MapDetailModule: MapDetailModuleProviding {

    var sceneFactory: MapDetailSceneFactory
    var interactor: MapDetailInteractor

    func makeMapDetailModule(for map: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapDetailScene()
        _ = MapDetailPresenter(scene: scene, interactor: interactor, identifier: map, delegate: delegate)

        return scene
    }

}
