@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenMapDetailSceneLoads_MapsPresenterShould: XCTestCase {

    func testBindTheMapFromTheViewModelOntoTheScene() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(interactor.viewModel.mapImagePNGData, context.scene.capturedMapImagePNGData)
    }

    func testBindTheNameOfTheMapAsTheTitleOntoTheScene() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(interactor.viewModel.mapName, context.scene.capturedTitle)
    }

}
