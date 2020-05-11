import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToRefresh_ScheduleViewModelShould: XCTestCase {

    func testTellTheRefreshServiceToRefresh() {
        let context = ScheduleViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
