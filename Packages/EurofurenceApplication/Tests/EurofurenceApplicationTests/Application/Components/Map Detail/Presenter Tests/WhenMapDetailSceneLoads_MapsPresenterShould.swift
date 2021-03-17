import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenMapDetailSceneLoads_MapsPresenterShould: XCTestCase {

    func testBindTheMap() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModelFactory.viewModel.mapImagePNGData, context.scene.capturedMapImagePNGData)
        XCTAssertEqual(viewModelFactory.viewModel.mapName, context.scene.capturedTitle)
    }

}
