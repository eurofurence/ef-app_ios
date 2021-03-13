import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenMapsSceneLoads_MapsPresenterShould: XCTestCase {

    func testBindTheNumberOfMapsFromTheViewModel() {
        let viewModel = FakeMapsViewModel()
        let viewModelFactory = FakeMapsViewModelFactory(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.numberOfMaps, context.scene.boundNumberOfMaps)
    }

}
