import EurofurenceModel
import UIKit

struct DealerDetailModule: DealerDetailModuleProviding {

    var dealerDetailSceneFactory: DealerDetailSceneFactory
    var dealerDetailInteractor: DealerDetailInteractor

    func makeDealerDetailModule(for dealer: DealerIdentifier) -> UIViewController {
        dealerDetailInteractor.makeDealerDetailViewModel(for: dealer) { (_) in }
        let scene = dealerDetailSceneFactory.makeDealerDetailScene()
        _ = DealerDetailPresenter(scene: scene, interactor: dealerDetailInteractor, dealer: dealer)

        return scene
    }

}
