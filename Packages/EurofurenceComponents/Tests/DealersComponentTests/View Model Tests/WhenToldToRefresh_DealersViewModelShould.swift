import DealersComponent
import EurofurenceModel
import XCTest

class WhenToldToRefresh_DealersViewModelShould: XCTestCase {

    func testTellTheRefreshServiceToRefresh() {
        let context = DealersViewModelTestBuilder().build()
        let viewModel = context.prepareViewModel()
        viewModel?.refresh()

        XCTAssertTrue(context.refreshService.toldToRefresh)
    }

}
