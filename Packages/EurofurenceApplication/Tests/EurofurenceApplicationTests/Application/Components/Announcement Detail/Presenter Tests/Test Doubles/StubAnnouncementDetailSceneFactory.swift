import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

class StubAnnouncementDetailSceneFactory: AnnouncementDetailSceneFactory {

    let stubbedScene = CapturingAnnouncementDetailScene()
    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene {
        return stubbedScene
    }

}
