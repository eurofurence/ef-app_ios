import Foundation
import UIKit

struct AnnouncementsComponentFactoryImpl: AnnouncementsComponentFactory {

    var announcementsSceneFactory: AnnouncementsSceneFactory
    var announcementsViewModelFactory: AnnouncementsViewModelFactory

    func makeAnnouncementsComponent(_ delegate: AnnouncementsComponentDelegate) -> UIViewController {
        let scene = announcementsSceneFactory.makeAnnouncementsScene()
        _ = AnnouncementsPresenter(
            scene: scene,
            announcementsViewModelFactory: announcementsViewModelFactory,
            delegate: delegate
        )

        return scene
    }

}
