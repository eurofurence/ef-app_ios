import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubMapDetailSceneFactory: MapDetailSceneFactory {

    let scene = CapturingMapDetailScene()
    func makeMapDetailScene() -> UIViewController & MapDetailScene {
        return scene
    }

}
