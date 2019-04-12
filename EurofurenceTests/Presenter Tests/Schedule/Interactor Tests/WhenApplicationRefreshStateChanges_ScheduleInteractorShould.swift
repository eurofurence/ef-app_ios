@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenApplicationRefreshStateChanges_ScheduleInteractorShould: XCTestCase {

    func testTellTheViewModelDelegateWhenRefreshStarts() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()

        XCTAssertTrue(delegate.viewModelDidBeginRefreshing)
    }

    func testTellTheViewModelDelegateWhenRefreshFinishes() {
        let context = ScheduleInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()
        context.refreshService.simulateRefreshFinished()

        XCTAssertTrue(delegate.viewModelDidFinishRefreshing)
    }

}
