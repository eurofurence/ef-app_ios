import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubHybridWebSceneFactory: HybridWebSceneFactory {

    let interface = CapturingHybridWebScene()
    func makeHybridWebScene() -> UIViewController & HybridWebScene {
        return interface
    }

}
