import Foundation
import UIKit

class AnnouncementsComponentBuilder {

    private var announcementsSceneFactory: AnnouncementsSceneFactory
    private var announcementsViewModelFactory: AnnouncementsViewModelFactory

    init(announcementsViewModelFactory: AnnouncementsViewModelFactory) {
        self.announcementsViewModelFactory = announcementsViewModelFactory
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
            announcementsViewModelFactory: announcementsViewModelFactory
        )
    }

}
