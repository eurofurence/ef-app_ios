class AnnouncementDetailModuleBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailInteractor: AnnouncementDetailInteractor

    init(announcementDetailInteractor: AnnouncementDetailInteractor) {
        self.announcementDetailInteractor = announcementDetailInteractor
        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> AnnouncementDetailModuleProviding {
        return AnnouncementDetailModule(sceneFactory: sceneFactory,
                                        announcementDetailInteractor: announcementDetailInteractor)
    }

}
