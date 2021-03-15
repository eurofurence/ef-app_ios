import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapPosition_ThatProvidesSimpleContextualDetail_MapsPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheDetailAtTheSpecifiedLocation() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: Float.random, y: Float.random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let expected = MapInformationContextualContent(coordinate: randomLocation, content: .random)
        viewModelFactory.viewModel.resolvePositionalContent(with: expected)

        XCTAssertEqual(expected, context.scene.presentedContextualContext)
    }

}
