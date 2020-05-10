import Foundation
import UIKit

class AnnouncementsComponentBuilder {

    private var announcementsSceneFactory: AnnouncementsSceneFactory
    private var announcementsInteractor: AnnouncementsInteractor

    init(announcementsInteractor: AnnouncementsInteractor) {
        self.announcementsInteractor = announcementsInteractor
        announcementsSceneFactory = StoryboardAnnouncementsSceneFactory()
    }
    
    @discardableResult
    func with(_ announcementsSceneFactory: AnnouncementsSceneFactory) -> AnnouncementsComponentBuilder {
        self.announcementsSceneFactory = announcementsSceneFactory
        return self
    }

    func build() -> AnnouncementsComponentFactory {
        AnnouncementsComponentFactoryImpl(
            announcementsSceneFactory: announcementsSceneFactory,
            announcementsInteractor: announcementsInteractor
        )
    }

}
