import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingUnreadAnnouncements_NewsPresenterShould: XCTestCase {

    func testTellTheBoundAnnouncementComponentToShowTheUnreadIndicator() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = false
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])

        let indexPath = IndexPath(row: 0, section: 0)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        XCTAssertTrue(context.newsScene.stubbedAnnouncementComponent.didShowUnreadIndicator)
    }

    func testNotTellTheBoundAnnouncementComponentToHideTheUnreadIndicator() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = false
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])

        let indexPath = IndexPath(row: 0, section: 0)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        XCTAssertFalse(context.newsScene.stubbedAnnouncementComponent.didHideUnreadIndicator)
    }

}
