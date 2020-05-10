import EurofurenceModel
import UIKit

struct DealerDetailComponentFactoryImpl: DealerDetailComponentFactory {

    var dealerDetailSceneFactory: DealerDetailSceneFactory
    var dealerDetailInteractor: DealerDetailViewModelFactory
    var dealerInteractionRecorder: DealerInteractionRecorder

    func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController {
        dealerDetailInteractor.makeDealerDetailViewModel(for: dealer) { (_) in }
        let scene = dealerDetailSceneFactory.makeDealerDetailScene()
        _ = DealerDetailPresenter(
            scene: scene,
            interactor: dealerDetailInteractor,
            dealer: dealer,
            dealerInteractionRecorder: dealerInteractionRecorder
        )

        return scene
    }

}
