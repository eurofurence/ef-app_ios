class AnnouncementDetailComponentBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory

    init(announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory) {
        self.announcementDetailViewModelFactory = announcementDetailViewModelFactory
        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailComponentBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> AnnouncementDetailComponentFactory {
        AnnouncementDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            announcementDetailViewModelFactory: announcementDetailViewModelFactory
        )
    }

}
