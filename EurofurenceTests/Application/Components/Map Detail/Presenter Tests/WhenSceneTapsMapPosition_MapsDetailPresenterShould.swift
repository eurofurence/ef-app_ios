@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapPosition_MapsDetailPresenterShould: XCTestCase {

    func testTellTheViewModelToShowTheMapContentsAtTheTappedLocation() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)

        XCTAssertEqual(randomLocation.x, viewModelFactory.viewModel.positionToldToShowMapContentsFor?.x)
        XCTAssertEqual(randomLocation.y, viewModelFactory.viewModel.positionToldToShowMapContentsFor?.y)
    }

}
