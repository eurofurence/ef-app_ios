import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubDealersSceneFactory: DealersSceneFactory {

    let scene = CapturingDealersScene()
    func makeDealersScene() -> UIViewController & DealersScene {
        return scene
    }

}
