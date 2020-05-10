@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingReadAnnouncements_NewsPresenterShould: XCTestCase {

    func testTellTheBoundAnnouncementComponentToHideTheUnreadIndicator() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = true
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])

        let indexPath = IndexPath(row: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        XCTAssertTrue(context.newsScene.stubbedAnnouncementComponent.didHideUnreadIndicator)
    }

    func testNotTellTheBoundAnnouncementComponentToShowTheUnreadIndicator() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = true
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])

        let indexPath = IndexPath(row: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        XCTAssertFalse(context.newsScene.stubbedAnnouncementComponent.didShowUnreadIndicator)
    }

}
