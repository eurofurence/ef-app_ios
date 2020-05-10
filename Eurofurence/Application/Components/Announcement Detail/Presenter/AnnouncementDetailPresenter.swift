import EurofurenceModel

struct AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private let scene: AnnouncementDetailScene
    private let announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory
    private let announcement: AnnouncementIdentifier

    init(
        scene: AnnouncementDetailScene,
        announcementDetailViewModelFactory: AnnouncementDetailViewModelFactory,
        announcement: AnnouncementIdentifier
    ) {
        self.scene = scene
        self.announcementDetailViewModelFactory = announcementDetailViewModelFactory
        self.announcement = announcement

        scene.setDelegate(self)
        scene.setAnnouncementTitle(.announcement)
    }

    func announcementDetailSceneDidLoad() {
        announcementDetailViewModelFactory.makeViewModel(
            for: announcement,
            completionHandler: announcementViewModelPrepared
        )
    }

    private func announcementViewModelPrepared(_ viewModel: AnnouncementDetailViewModel) {
        scene.setAnnouncementContents(viewModel.contents)
        scene.setAnnouncementHeading(viewModel.heading)
        viewModel.imagePNGData.let(scene.setAnnouncementImagePNGData)
    }

}
