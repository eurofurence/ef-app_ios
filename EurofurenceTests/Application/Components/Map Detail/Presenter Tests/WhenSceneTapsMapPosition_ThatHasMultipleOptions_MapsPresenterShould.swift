import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsMapPosition_ThatHasMultipleOptions_MapsPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheOptions() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let x = Float.random
        let y = Float.random
        let randomLocation = MapCoordinate(x: x, y: y)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let contentOptions = StubMapContentOptionsViewModel.random
        viewModelFactory.viewModel.resolvePositionalContent(with: contentOptions)

        XCTAssertEqual(contentOptions.optionsHeading, context.scene.capturedOptionsHeading)
        XCTAssertEqual(contentOptions.options, context.scene.capturedOptionsToShow)
        XCTAssertEqual(x, context.scene.capturedOptionsPresentationX.defaultingTo(.random), accuracy: .ulpOfOne)
        XCTAssertEqual(y, context.scene.capturedOptionsPresentationY.defaultingTo(.random), accuracy: .ulpOfOne)
    }

    func testTellTheViewModelWhichOptionIsSelected() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()
        let randomLocation = MapCoordinate(x: .random, y: .random)
        context.simulateSceneDidDidTapMap(at: randomLocation)
        let contentOptions = StubMapContentOptionsViewModel.random
        viewModelFactory.viewModel.resolvePositionalContent(with: contentOptions)
        let selectedOptionIndex = contentOptions.options.randomElement().index
        context.simulateSceneTappedMapOption(at: selectedOptionIndex)

        XCTAssertEqual(selectedOptionIndex, contentOptions.selectedOptionIndex)
    }

}
