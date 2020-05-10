import Foundation

class AnnouncementsPresenter: AnnouncementsSceneDelegate, AnnouncementsListViewModelDelegate {

    private struct Binder: AnnouncementsBinder {

        var viewModel: AnnouncementsListViewModel

        func bind(_ component: AnnouncementItemComponent, at index: Int) {
            let announcement = viewModel.announcementViewModel(at: index)

            component.setAnnouncementTitle(announcement.title)
            component.setAnnouncementDetail(announcement.detail)
            component.setAnnouncementReceivedDateTime(announcement.receivedDateTime)

            if announcement.isRead {
                component.hideUnreadIndicator()
            } else {
                component.showUnreadIndicator()
            }
        }

    }

    private let scene: AnnouncementsScene
    private let interactor: AnnouncementsViewModelFactory
    private let delegate: AnnouncementsComponentDelegate
    private var viewModel: AnnouncementsListViewModel?

    init(scene: AnnouncementsScene, interactor: AnnouncementsViewModelFactory, delegate: AnnouncementsComponentDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.delegate = delegate

        scene.setAnnouncementsTitle(.announcements)
        scene.setDelegate(self)
    }

    func announcementsSceneDidLoad() {
        interactor.makeViewModel(completionHandler: viewModelPrepared)
    }

    func announcementsSceneDidSelectAnnouncement(at index: Int) {
        scene.deselectAnnouncement(at: index)

        guard let identifier = viewModel?.identifierForAnnouncement(at: index) else { return }
        delegate.announcementsComponentDidSelectAnnouncement(identifier)
    }

    func announcementsViewModelDidChangeAnnouncements() {
        guard let viewModel = viewModel else { return }
        scene.bind(numberOfAnnouncements: viewModel.numberOfAnnouncements, using: Binder(viewModel: viewModel))
    }

    private func viewModelPrepared(_ viewModel: AnnouncementsListViewModel) {
        self.viewModel = viewModel
        viewModel.setDelegate(self)
        scene.bind(numberOfAnnouncements: viewModel.numberOfAnnouncements, using: Binder(viewModel: viewModel))
    }

}
