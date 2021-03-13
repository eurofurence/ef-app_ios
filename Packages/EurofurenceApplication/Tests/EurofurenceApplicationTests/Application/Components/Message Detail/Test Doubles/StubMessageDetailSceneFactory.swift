import EurofurenceApplication
import UIKit

struct StubMessageDetailSceneFactory: MessageDetailSceneFactory {

    let scene = CapturingMessageDetailScene()
    func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
        return scene
    }

}
