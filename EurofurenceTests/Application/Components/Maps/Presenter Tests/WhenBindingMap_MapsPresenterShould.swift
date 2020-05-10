@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingMap_MapsPresenterShould: XCTestCase {

    func testBindTheNameOfTheMapOntoTheComponent() {
        let viewModel = FakeMapsViewModel()
        let viewModelFactory = FakeMapsViewModelFactory(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        let boundComponent = context.bindMap(at: mapViewModel.index)

        XCTAssertEqual(mapViewModel.element.mapName, boundComponent.boundMapName)
    }

    func testBindTheMapPreviewOntoTheComponent() {
        let viewModel = FakeMapsViewModel()
        let viewModelFactory = FakeMapsViewModelFactory(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        let boundComponent = context.bindMap(at: mapViewModel.index)

        XCTAssertEqual(mapViewModel.element.mapPreviewImagePNGData, boundComponent.boundMapPreviewData)
    }

}
