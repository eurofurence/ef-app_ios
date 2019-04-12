@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenInstigatingPullToRefreshAction_SchedulePresenterShould: XCTestCase {

    var context: SchedulePresenterTestBuilder.Context!
    var viewModel: CapturingScheduleViewModel!

    override func setUp() {
        super.setUp()

        viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        context = SchedulePresenterTestBuilder().with(interactor).build()
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
