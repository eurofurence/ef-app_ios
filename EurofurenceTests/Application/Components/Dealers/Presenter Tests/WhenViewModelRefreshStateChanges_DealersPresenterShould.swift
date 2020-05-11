import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewModelRefreshStateChanges_DealersPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheRefreshingIndicatorWhileRefreshing() {
        let viewModel = CapturingDealersViewModel()
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        
        XCTAssertFalse(context.scene.didShowRefreshIndicator)
        XCTAssertFalse(context.scene.didHideRefreshIndicator)
        
        viewModel.delegate?.dealersRefreshDidBegin()

        XCTAssertTrue(context.scene.didShowRefreshIndicator)
        XCTAssertFalse(context.scene.didHideRefreshIndicator)
        
        viewModel.delegate?.dealersRefreshDidFinish()
        
        XCTAssertTrue(context.scene.didHideRefreshIndicator)
    }

}
