import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenAnnouncementsViewModelUpdatesAnnouncements_AnnouncementsPresenterShould: XCTestCase {

    func testRebindTheNewAnnouncements() {
        let viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let newAnnouncements = [AnnouncementItemViewModel].random
        viewModel.simulateUpdatedAnnouncements(newAnnouncements)

        XCTAssertEqual(newAnnouncements.count, context.scene.capturedAnnouncementsToBind)
    }

}
