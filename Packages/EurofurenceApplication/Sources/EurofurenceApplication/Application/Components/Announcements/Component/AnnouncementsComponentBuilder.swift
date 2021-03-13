import Foundation
import UIKit

public class AnnouncementsComponentBuilder {

    private var announcementsSceneFactory: AnnouncementsSceneFactory
    private var announcementsViewModelFactory: AnnouncementsViewModelFactory

    public init(announcementsViewModelFactory: AnnouncementsViewModelFactory) {
        self.announcementsViewModelFactory = announcementsViewModelFactory
        announcementsSceneFactory = StoryboardAnnouncementsSceneFactory()
    }
    
    @discardableResult
    public func with(_ announcementsSceneFactory: AnnouncementsSceneFactory) -> AnnouncementsComponentBuilder {
        self.announcementsSceneFactory = announcementsSceneFactory
        return self
    }

    public func build() -> AnnouncementsComponentFactory {
        AnnouncementsComponentFactoryImpl(
            announcementsSceneFactory: announcementsSceneFactory,
            announcementsViewModelFactory: announcementsViewModelFactory
        )
    }

}
