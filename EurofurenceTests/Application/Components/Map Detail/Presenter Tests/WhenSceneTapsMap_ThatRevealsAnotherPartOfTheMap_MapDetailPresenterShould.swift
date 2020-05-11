import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMap_ThatRevealsAnotherPartOfTheMap_MapDetailPresenterShould: XCTestCase {

    func testTellTheMapToFocusOnSpecificPoint() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let expected = MapCoordinate(x: .random, y: .random)
        viewModelFactory.viewModel.resolvePositionalContent(with: expected)

        XCTAssertEqual(expected, context.scene.capturedMapPositionToFocus)
    }

}
