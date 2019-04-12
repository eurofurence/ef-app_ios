@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_ScheduleViewModelShould: XCTestCase {

    func testTellTheRefreshServiceToRefresh() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
