import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingMap_MapsPresenterShould: XCTestCase {

    func testBindMapOntoTheComponent() {
        let viewModel = FakeMapsViewModel()
        let viewModelFactory = FakeMapsViewModelFactory(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        let boundComponent = context.bindMap(at: mapViewModel.index)

        XCTAssertEqual(mapViewModel.element.mapName, boundComponent.boundMapName)
        XCTAssertEqual(mapViewModel.element.mapPreviewImagePNGData, boundComponent.boundMapPreviewData)
    }

}
