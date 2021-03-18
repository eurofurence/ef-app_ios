import DealerComponent
import EurofurenceModel
import UIKit

class StubDealerDetailSceneFactory: DealerDetailSceneFactory {

    let scene = CapturingDealerDetailScene()
    func makeDealerDetailScene() -> UIViewController & DealerDetailScene {
        return scene
    }

}
