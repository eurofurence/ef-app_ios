import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenBindingAnnouncement_NewsPresenterShould: XCTestCase {

    var viewModel: AnnouncementsViewModel!
    var announcementViewModel: AnnouncementItemViewModel!
    var indexPath: IndexPath!
    var newsViewModelFactory: StubNewsViewModelProducer!
    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        viewModel = AnnouncementsViewModel()
        let component = viewModel.announcements.randomElement()
        let announcement = component.element.randomElement()
        announcementViewModel = announcement.element
        indexPath = IndexPath(row: announcement.index, section: component.index)

        newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }

    func testSetTheAnnouncementNameOntoTheAnnouncementScene() {
        XCTAssertEqual(announcementViewModel.title, context.newsScene.stubbedAnnouncementComponent.capturedTitle)
    }

    func testSetTheAnnouncementDetailOntoTheAnnouncementScene() {
        XCTAssertEqual(announcementViewModel.detail, context.newsScene.stubbedAnnouncementComponent.capturedDetail)
    }

    func testSetTheAnnouncementDateTimeOntoTheAnnouncementScene() {
        XCTAssertEqual(
            announcementViewModel.receivedDateTime,
            context.newsScene.stubbedAnnouncementComponent.capturedReceivedDateTime
        )
    }

    func testTellTheDelegateAnnouncementSelectedWhenSceneSelectsComponentAtIndexPath() {
        let announcement = FakeAnnouncement.random
        viewModel.stub(.announcement(announcement.identifier), at: indexPath)
        context.selectComponent(at: indexPath)

        XCTAssertEqual(announcement.identifier, context.delegate.capturedAnnouncement)
    }

    func testNotTellTheDelegateToShowPrivateMessagesWhenSelectingAnnouncement() {
        let announcement = FakeAnnouncement.random
        viewModel.stub(.announcement(announcement.identifier), at: indexPath)
        context.selectComponent(at: indexPath)

        XCTAssertFalse(context.delegate.showPrivateMessagesRequested)
    }

}
