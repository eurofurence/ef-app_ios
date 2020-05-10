import EurofurenceModel

struct AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private let scene: AnnouncementDetailScene
    private let interactor: AnnouncementDetailViewModelFactory
    private let announcement: AnnouncementIdentifier

    init(scene: AnnouncementDetailScene, interactor: AnnouncementDetailViewModelFactory, announcement: AnnouncementIdentifier) {
        self.scene = scene
        self.interactor = interactor
        self.announcement = announcement

        scene.setDelegate(self)
        scene.setAnnouncementTitle(.announcement)
    }

    func announcementDetailSceneDidLoad() {
        interactor.makeViewModel(for: announcement, completionHandler: announcementViewModelPrepared)
    }

    private func announcementViewModelPrepared(_ viewModel: AnnouncementDetailViewModel) {
        scene.setAnnouncementContents(viewModel.contents)
        scene.setAnnouncementHeading(viewModel.heading)
        viewModel.imagePNGData.let(scene.setAnnouncementImagePNGData)
    }

}
