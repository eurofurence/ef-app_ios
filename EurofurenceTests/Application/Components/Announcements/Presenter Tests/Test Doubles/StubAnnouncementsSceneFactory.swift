import Eurofurence
import EurofurenceModel
import UIKit

class StubAnnouncementsSceneFactory: AnnouncementsSceneFactory {

    let scene = CapturingAnnouncementsScene()
    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene {
        return scene
    }

}
