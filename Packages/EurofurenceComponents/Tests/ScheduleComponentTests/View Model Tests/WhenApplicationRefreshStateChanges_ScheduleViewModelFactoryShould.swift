import EurofurenceModel
import ScheduleComponent
import XCTest

class WhenApplicationRefreshStateChanges_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheViewModelDelegateWhenRefreshStarts() {
        let context = ScheduleViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()

        XCTAssertTrue(delegate.viewModelDidBeginRefreshing)
    }

    func testTellTheViewModelDelegateWhenRefreshFinishes() {
        let context = ScheduleViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.refresh()
        let delegate = CapturingScheduleViewModelDelegate()
        viewModel?.setDelegate(delegate)
        context.refreshService.simulateRefreshBegan()
        context.refreshService.simulateRefreshFinished()

        XCTAssertTrue(delegate.viewModelDidFinishRefreshing)
    }

}
