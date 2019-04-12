@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapPosition_ThatProvidesSimpleContextualDetail_MapsPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheDetailAtTheSpecifiedLocation() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let expected = MapInformationContextualContent(coordinate: randomLocation, content: .random)
        interactor.viewModel.resolvePositionalContent(with: expected)

        XCTAssertEqual(expected, context.scene.presentedContextualContext)
    }

}
