import Foundation
import UIKit

struct AnnouncementsModule: AnnouncementsModuleProviding {

    var announcementsSceneFactory: AnnouncementsSceneFactory
    var announcementsInteractor: AnnouncementsInteractor

    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        let scene = announcementsSceneFactory.makeAnnouncementsScene()
        _ = AnnouncementsPresenter(scene: scene, interactor: announcementsInteractor, delegate: delegate)

        return scene
    }

}
