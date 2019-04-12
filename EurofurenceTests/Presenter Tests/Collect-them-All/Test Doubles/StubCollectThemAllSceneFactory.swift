@testable import Eurofurence
import EurofurenceModel
import UIKit

class StubCollectThemAllSceneFactory: CollectThemAllSceneFactory {

    let interface = CapturingCollectThemAllScene()
    func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene {
        return interface
    }

}
