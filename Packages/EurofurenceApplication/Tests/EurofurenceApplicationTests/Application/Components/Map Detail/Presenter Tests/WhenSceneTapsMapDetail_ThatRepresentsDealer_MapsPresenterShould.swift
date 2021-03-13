import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapDetail_ThatRepresentsDealer_MapsPresenterShould: XCTestCase {

    func testTellTheModuleDelegateToShowDealer() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let dealerIdentifier = DealerIdentifier.random
        viewModelFactory.viewModel.resolvePositionalContent(with: dealerIdentifier)

        XCTAssertEqual(dealerIdentifier, context.delegate.capturedDealerToShow)
    }

}
