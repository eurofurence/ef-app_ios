@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewModelRefreshStateChanges_DealersPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheRefreshingIndicatorWhenRefreshBegins() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        viewModel.delegate?.dealersRefreshDidBegin()

        XCTAssertTrue(context.scene.didShowRefreshIndicator)
    }

    func testTellTheSceneToHideTheRefreshingIndicatorWhenRefreshFinishes() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        viewModel.delegate?.dealersRefreshDidFinish()

        XCTAssertTrue(context.scene.didHideRefreshIndicator)
    }

}
