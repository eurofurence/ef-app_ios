import Eurofurence
import EurofurenceModel
import XCTest

class WhenApplicationRefreshStateChanges_DealersViewModelShould: XCTestCase {

    func testTellTheDelegateRefreshDidBegin() {
        let context = DealersViewModelTestBuilder().build()
        let viewModel = context.prepareViewModel()
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()

        XCTAssertTrue(delegate.toldRefreshDidBegin)
    }

    func testTellTheDelegateRefreshDidFinish() {
        let context = DealersViewModelTestBuilder().build()
        let viewModel = context.prepareViewModel()
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshFinished()

        XCTAssertTrue(delegate.toldRefreshDidFinish)
    }

}
