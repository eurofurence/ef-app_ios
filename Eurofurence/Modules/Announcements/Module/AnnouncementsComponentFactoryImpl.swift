import Foundation
import UIKit

struct AnnouncementsComponentFactoryImpl: AnnouncementsComponentFactory {

    var announcementsSceneFactory: AnnouncementsSceneFactory
    var announcementsInteractor: AnnouncementsInteractor

    func makeAnnouncementsComponent(_ delegate: AnnouncementsComponentDelegate) -> UIViewController {
        let scene = announcementsSceneFactory.makeAnnouncementsScene()
        _ = AnnouncementsPresenter(
            scene: scene,
            interactor: announcementsInteractor,
            delegate: delegate
        )

        return scene
    }

}
