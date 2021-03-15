import UIKit.UIViewController

struct DealersComponentFactoryImpl: DealersComponentFactory {

    var dealersSceneFactory: DealersSceneFactory
    var dealersViewModelFactory: DealersViewModelFactory

    func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController {
        let scene = dealersSceneFactory.makeDealersScene()
        _ = DealersPresenter(
            scene: scene,
            dealersViewModelFactory: dealersViewModelFactory,
            delegate: delegate
        )

        return scene
    }

}
