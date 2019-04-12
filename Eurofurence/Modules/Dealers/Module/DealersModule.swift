import UIKit.UIViewController

struct DealersModule: DealersModuleProviding {

    var dealersSceneFactory: DealersSceneFactory
    var interactor: DealersInteractor

    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        let scene = dealersSceneFactory.makeDealersScene()
        _ = DealersPresenter(scene: scene, interactor: interactor, delegate: delegate)

        return scene
    }

}
