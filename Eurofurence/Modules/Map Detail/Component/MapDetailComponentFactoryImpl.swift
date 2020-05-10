import EurofurenceModel
import UIKit

struct MapDetailComponentFactoryImpl: MapDetailComponentFactory {

    var sceneFactory: MapDetailSceneFactory
    var mapDetailViewModelFactory: MapDetailViewModelFactory

    func makeMapDetailComponent(for map: MapIdentifier, delegate: MapDetailComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapDetailScene()
        _ = MapDetailPresenter(
            scene: scene,
            mapDetailViewModelFactory: mapDetailViewModelFactory,
            identifier: map,
            delegate: delegate
        )

        return scene
    }

}
