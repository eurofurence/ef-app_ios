@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenAnnouncementsViewModelUpdatesAnnouncements_AnnouncementsPresenterShould: XCTestCase {

    func testRebindTheNewAnnouncements() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let newAnnouncements = [AnnouncementComponentViewModel].random
        viewModel.simulateUpdatedAnnouncements(newAnnouncements)

        XCTAssertEqual(newAnnouncements.count, context.scene.capturedAnnouncementsToBind)
    }

}
