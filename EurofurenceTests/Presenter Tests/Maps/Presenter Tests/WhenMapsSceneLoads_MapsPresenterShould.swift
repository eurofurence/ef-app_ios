@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenMapsSceneLoads_MapsPresenterShould: XCTestCase {

    func testBindTheNumberOfMapsFromTheViewModel() {
        let viewModel = FakeMapsViewModel()
        let interactor = FakeMapsInteractor(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.numberOfMaps, context.scene.boundNumberOfMaps)
    }

}
