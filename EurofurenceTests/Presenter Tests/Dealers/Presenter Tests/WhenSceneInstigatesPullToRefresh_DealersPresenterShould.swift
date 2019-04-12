@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneInstigatesPullToRefresh_DealersPresenterShould: XCTestCase {

    func testTellTheViewModelToRefresh() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()

        XCTAssertTrue(viewModel.wasToldToRefresh)
    }

}
