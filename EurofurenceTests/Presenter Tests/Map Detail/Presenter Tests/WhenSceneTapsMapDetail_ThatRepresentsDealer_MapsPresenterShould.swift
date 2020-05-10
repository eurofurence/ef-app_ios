@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapDetail_ThatRepresentsDealer_MapsPresenterShould: XCTestCase {

    func testTellTheModuleDelegateToShowDealer() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let dealerIdentifier = DealerIdentifier.random
        interactor.viewModel.resolvePositionalContent(with: dealerIdentifier)

        XCTAssertEqual(dealerIdentifier, context.delegate.capturedDealerToShow)
    }

}
