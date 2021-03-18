import EurofurenceModel

import UIKit

struct DealerDetailComponentFactoryImpl: DealerDetailComponentFactory {

    var dealerDetailSceneFactory: DealerDetailSceneFactory
    var dealerDetailViewModelFactory: DealerDetailViewModelFactory
    var dealerInteractionRecorder: DealerInteractionRecorder

    func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController {
        let scene = dealerDetailSceneFactory.makeDealerDetailScene()
        _ = DealerDetailPresenter(
            scene: scene,
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealer: dealer,
            dealerInteractionRecorder: dealerInteractionRecorder
        )

        return scene
    }

}
