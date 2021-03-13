import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenApplicationRefreshStateChanges_DealersViewModelShould: XCTestCase {

    func testTellTheDelegateRefreshDidBegin() {
        let context = DealersViewModelTestBuilder().build()
        let viewModel = context.prepareViewModel()
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        
        XCTAssertFalse(delegate.toldRefreshDidBegin)
        XCTAssertFalse(delegate.toldRefreshDidFinish)
        
        context.refreshService.simulateRefreshBegan()

        XCTAssertTrue(delegate.toldRefreshDidBegin)
        XCTAssertFalse(delegate.toldRefreshDidFinish)
        
        context.refreshService.simulateRefreshFinished()
        
        XCTAssertTrue(delegate.toldRefreshDidFinish)
    }

}
