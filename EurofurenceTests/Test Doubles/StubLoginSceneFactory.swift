@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubLoginSceneFactory: LoginSceneFactory {

    let stubScene = CapturingLoginScene()
    func makeLoginScene() -> UIViewController & LoginScene {
        return stubScene
    }

}
