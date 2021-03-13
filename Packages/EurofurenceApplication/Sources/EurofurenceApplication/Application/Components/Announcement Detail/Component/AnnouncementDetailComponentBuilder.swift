public class AnnouncementDetailComponentBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory

    public init(announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory) {
        self.announcementDetailViewModelFactory = announcementDetailViewModelFactory
        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
    }

    @discardableResult
    public func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> AnnouncementDetailComponentFactory {
        AnnouncementDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            announcementDetailViewModelFactory: announcementDetailViewModelFactory
        )
    }

}
