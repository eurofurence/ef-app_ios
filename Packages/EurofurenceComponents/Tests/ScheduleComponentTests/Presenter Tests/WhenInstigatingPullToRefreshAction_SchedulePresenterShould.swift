import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenInstigatingPullToRefreshAction_SchedulePresenterShould: XCTestCase {

    var context: SchedulePresenterTestBuilder.Context!
    var viewModel: CapturingScheduleViewModel!

    override func setUp() {
        super.setUp()

        viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()
    }

    func testTellTheViewModelToRefresh() {
        XCTAssertTrue(viewModel.didPerformRefresh)
    }

    func testShowTheRefreshIndicatorWhenRefreshBegins() {
        viewModel.simulateScheduleRefreshDidBegin()

        XCTAssertTrue(context.scene.didShowRefreshIndicator)
    }

    func testHideTheRefreshIndicatorWhenRefreshFinishes() {
        viewModel.simulateScheduleRefreshDidBegin()
        viewModel.simulateScheduleRefreshDidFinish()

        XCTAssertTrue(context.scene.didHideRefreshIndicator)
    }

}
