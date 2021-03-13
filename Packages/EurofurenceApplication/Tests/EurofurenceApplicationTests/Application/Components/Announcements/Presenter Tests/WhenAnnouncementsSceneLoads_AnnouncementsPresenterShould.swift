import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould: XCTestCase {

    func testBindTheNumberOfAnnouncementsFromTheViewModelOntoTheScene() {
        let viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.announcements.count, context.scene.capturedAnnouncementsToBind)
    }

}
