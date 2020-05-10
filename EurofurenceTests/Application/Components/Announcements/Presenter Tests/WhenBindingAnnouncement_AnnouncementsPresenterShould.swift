@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAnnouncement_AnnouncementsPresenterShould: XCTestCase {

    func testBindTheTitleOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)

        XCTAssertEqual(randomAnnouncement.element.title, boundComponent.capturedTitle)
    }

    func testBindTheSubtitleOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)

        XCTAssertEqual(randomAnnouncement.element.detail, boundComponent.capturedDetail)
    }

    func testBindTheAnnouncementDateTimeOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)

        XCTAssertEqual(randomAnnouncement.element.receivedDateTime, boundComponent.capturedReceivedDateTime)
    }

    func testTellTheSceneToHideTheUnreadIndicatorForReadAnnouncements() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = true
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertTrue(boundComponent.didHideUnreadIndicator)
    }

    func testNotTellTheSceneToHideTheUnreadIndicatorForUnreadAnnouncements() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = false
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertFalse(boundComponent.didHideUnreadIndicator)
    }

    func testTellTheSceneToShowTheUnreadIndicatorForUnreadAnnouncements() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = false
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertTrue(boundComponent.didShowUnreadIndicator)
    }

    func testNotTellTheSceneToShowTheUnreadIndicatorForReadAnnouncements() {
        var announcement = AnnouncementItemViewModel.random
        announcement.isRead = true
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertFalse(boundComponent.didShowUnreadIndicator)
    }

}