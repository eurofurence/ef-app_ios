import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_AnnouncementsViewModelFactoryShould: XCTestCase {

    var announcementsService: FakeAnnouncementsRepository!
    var viewModelFactory: DefaultAnnouncementsViewModelFactory!
    var announcementDateFormatter: FakeAnnouncementDateFormatter!
	var markdownRenderer: StubMarkdownRenderer!
    var announcements: [Announcement]!
    var announcement: (index: Int, element: Announcement)!

    override func setUp() {
        super.setUp()

        announcements = [StubAnnouncement].random
        announcement = announcements.randomElement()
        announcementsService = FakeAnnouncementsRepository(announcements: announcements)
        announcementDateFormatter = FakeAnnouncementDateFormatter()
		markdownRenderer = StubMarkdownRenderer()
		viewModelFactory = DefaultAnnouncementsViewModelFactory(
            announcementsService: announcementsService,
            announcementDateFormatter: announcementDateFormatter,
            markdownRenderer: markdownRenderer
        )
    }

    func testAdaptAnnouncementsAndTheirAttributes() {
        var viewModel: AnnouncementsListViewModel?
        viewModelFactory.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)
        let expectedDetail = markdownRenderer.stubbedContents(for: announcement.element.content)
        let expectedFormattedDate = announcementDateFormatter.string(from: announcement.element.date)

        XCTAssertEqual(announcements.count, viewModel?.numberOfAnnouncements)
        XCTAssertEqual(announcement.element.title, announcementViewModel?.title)
        XCTAssertEqual(expectedDetail, announcementViewModel?.detail)
        XCTAssertEqual(expectedFormattedDate, announcementViewModel?.receivedDateTime)
        XCTAssertEqual(false, announcementViewModel?.isRead)
        XCTAssertEqual(announcement.element.identifier, viewModel?.identifierForAnnouncement(at: announcement.index))
    }

    func testAdaptReadAnnouncements() {
        var viewModel: AnnouncementsListViewModel?
        announcementsService.stubbedReadAnnouncements = [announcement.element.identifier]
        viewModelFactory.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(true, announcementViewModel?.isRead)
    }

    func testUpdateTheAvailableViewModelsWhenAnnouncementsChange() {
        var viewModel: AnnouncementsListViewModel?
        viewModelFactory.makeViewModel { viewModel = $0 }
        let newAnnouncements = [StubAnnouncement].random(upperLimit: announcements.count)
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateAnnouncements(newAnnouncements)
        let announcement = newAnnouncements.randomElement()
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(announcement.element.title, announcementViewModel?.title)
        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }

    func testUpdateTheAvailableViewModelsWhenReadAnnouncementsChange() {
        var viewModel: AnnouncementsListViewModel?
        viewModelFactory.makeViewModel { viewModel = $0 }
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateReadAnnouncements(.random)

        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }

}
