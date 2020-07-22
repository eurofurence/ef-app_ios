import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsDealer_DealersPresenterShould: XCTestCase {

    func testNotifyTheDelegateAndDeselectTheDealer() {
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

}
