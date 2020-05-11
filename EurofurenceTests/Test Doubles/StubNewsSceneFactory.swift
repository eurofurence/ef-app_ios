import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubNewsSceneFactory: NewsSceneFactory {

    let stubbedScene = CapturingNewsScene()
    func makeNewsScene() -> UIViewController & NewsScene {
        return stubbedScene
    }

}
