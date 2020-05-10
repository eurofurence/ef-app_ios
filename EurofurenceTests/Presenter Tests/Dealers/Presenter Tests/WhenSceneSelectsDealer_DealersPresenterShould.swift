@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsDealer_DealersPresenterShould: XCTestCase {

    func testTellTheModuleDelegateTheDealerIdentifierForTheIndexPathWasSelected() {
        let viewModel = CapturingDealersViewModel()
        let identifier = DealerIdentifier.random
        let indexPath = IndexPath.random
        viewModel.stub(identifier, forDealerAt: indexPath)
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectDealer(at: indexPath)

        XCTAssertEqual(identifier, context.delegate.capturedSelectedDealerIdentifier)
    }

    func testTellTheSceneToDeselectTheSelectedDealer() {
        let indexPath = IndexPath.random
        let context = DealersPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectDealer(at: indexPath)

        XCTAssertEqual(indexPath, context.scene.capturedIndexPathToDeselect)
    }

}
