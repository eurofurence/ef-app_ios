import UIKit.UIViewController

struct DealersComponentFactoryImpl: DealersComponentFactory {

    var dealersSceneFactory: DealersSceneFactory
    var interactor: DealersViewModelFactory

    func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController {
        let scene = dealersSceneFactory.makeDealersScene()
        _ = DealersPresenter(scene: scene, interactor: interactor, delegate: delegate)

        return scene
    }

}
