import EurofurenceModel
import UIKit

struct MapDetailComponentFactoryImpl: MapDetailComponentFactory {

    var sceneFactory: MapDetailSceneFactory
    var interactor: MapDetailViewModelFactory

    func makeMapDetailComponent(for map: MapIdentifier, delegate: MapDetailComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapDetailScene()
        _ = MapDetailPresenter(
            scene: scene,
            interactor: interactor,
            identifier: map,
            delegate: delegate
        )

        return scene
    }

}
