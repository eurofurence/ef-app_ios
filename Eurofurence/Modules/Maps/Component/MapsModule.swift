import UIKit

struct MapsComponentFactoryImpl: MapsComponentFactory {

    var sceneFactory: MapsSceneFactory
    var interactor: MapsViewModelFactory

    func makeMapsModule(_ delegate: MapsComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeMapsScene()
        _ = MapsPresenter(scene: scene, interactor: interactor, delegate: delegate)

        return scene
    }

}
