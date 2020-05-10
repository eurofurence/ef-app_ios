class AnnouncementDetailComponentBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailInteractor: AnnouncementDetailInteractor

    init(announcementDetailInteractor: AnnouncementDetailInteractor) {
        self.announcementDetailInteractor = announcementDetailInteractor
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
            announcementDetailInteractor: announcementDetailInteractor
        )
    }

}
