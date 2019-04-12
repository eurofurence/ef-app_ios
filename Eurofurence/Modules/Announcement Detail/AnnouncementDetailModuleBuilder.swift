class AnnouncementDetailModuleBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory
    private var announcementDetailInteractor: AnnouncementDetailInteractor

    init() {
        sceneFactory = StoryboardAnnouncementDetailSceneFactory()
        announcementDetailInteractor = DefaultAnnouncementDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ announcementDetailInteractor: AnnouncementDetailInteractor) -> AnnouncementDetailModuleBuilder {
        self.announcementDetailInteractor = announcementDetailInteractor
        return self
    }

    func build() -> AnnouncementDetailModuleProviding {
        return AnnouncementDetailModule(sceneFactory: sceneFactory,
                                        announcementDetailInteractor: announcementDetailInteractor)
    }

}
