import EurofurenceModel
import UIKit.UIViewController

struct AnnouncementDetailComponentFactoryImpl: AnnouncementDetailComponentFactory {

    var sceneFactory: AnnouncementDetailSceneFactory
    var announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory

    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        let scene = sceneFactory.makeAnnouncementDetailScene()
        _ = AnnouncementDetailPresenter(
            scene: scene,
            interactor: announcementDetailViewModelFactory,
            announcement: announcement
        )

        return scene
    }

}
