@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenMapDetailSceneLoads_MapsPresenterShould: XCTestCase {

    func testBindTheMapFromTheViewModelOntoTheScene() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModelFactory.viewModel.mapImagePNGData, context.scene.capturedMapImagePNGData)
    }

    func testBindTheNameOfTheMapAsTheTitleOntoTheScene() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModelFactory.viewModel.mapName, context.scene.capturedTitle)
    }

}
