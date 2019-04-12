import EurofurenceModel
import UIKit.UIViewController

struct AnnouncementDetailModule: AnnouncementDetailModuleProviding {

    var sceneFactory: AnnouncementDetailSceneFactory
    var announcementDetailInteractor: AnnouncementDetailInteractor

    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        let scene = sceneFactory.makeAnnouncementDetailScene()
        _ = AnnouncementDetailPresenter(scene: scene,
                                        interactor: announcementDetailInteractor,
                                        announcement: announcement)

        return scene
    }

}
