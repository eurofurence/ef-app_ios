import UIKit

struct MapsComponentFactoryImpl: MapsComponentFactory {

    var sceneFactory: MapsSceneFactory
    var mapsViewModelFactory: MapsViewModelFactory

    func makeMapsModule(_ delegate: MapsComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapsScene()
        _ = MapsPresenter(
            scene: scene,
            mapsViewModelFactory: mapsViewModelFactory,
            delegate: delegate
        )

        return scene
    }

}
