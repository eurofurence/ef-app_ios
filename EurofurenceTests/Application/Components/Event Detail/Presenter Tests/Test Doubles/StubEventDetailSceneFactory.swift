import Eurofurence
import EurofurenceModel
import Foundation
import UIKit.UIViewController

class StubEventDetailSceneFactory: EventDetailSceneFactory {

    let interface = CapturingEventDetailScene()
    func makeEventDetailScene() -> UIViewController & EventDetailScene {
        return interface
    }

}
