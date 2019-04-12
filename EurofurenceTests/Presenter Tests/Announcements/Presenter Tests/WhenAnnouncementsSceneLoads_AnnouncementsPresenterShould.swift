@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenAnnouncementsSceneLoads_AnnouncementsPresenterShould: XCTestCase {

    func testBindTheNumberOfAnnouncementsFromTheViewModelOntoTheScene() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.announcements.count, context.scene.capturedAnnouncementsToBind)
    }

}
