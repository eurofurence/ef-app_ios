import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenSceneInstigatesPullToRefresh_DealersPresenterShould: XCTestCase {

    func testTellTheViewModelToRefresh() {
        let viewModel = CapturingDealersViewModel()
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()

        XCTAssertTrue(viewModel.wasToldToRefresh)
    }

}
