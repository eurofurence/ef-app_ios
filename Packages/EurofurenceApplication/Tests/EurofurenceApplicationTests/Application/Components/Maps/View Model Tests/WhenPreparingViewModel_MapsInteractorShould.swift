import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_MapsViewModelFactoryShould: XCTestCase {

    func testAdaptNumberOfMapsFromServiceIntoMapsCount() {
        let mapsService = FakeMapsService()
        let viewModelFactory = DefaultMapsViewModelFactory(mapsService: mapsService)
        var viewModel: MapsViewModel?
        viewModelFactory.makeMapsViewModel { viewModel = $0 }

        XCTAssertEqual(mapsService.maps.count, viewModel?.numberOfMaps)
    }

    func testAdaptMapIntoViewModel() {
        let mapsService = FakeMapsService()
        let viewModelFactory = DefaultMapsViewModelFactory(mapsService: mapsService)
        var viewModel: MapsViewModel?
        viewModelFactory.makeMapsViewModel { viewModel = $0 }
        let randomMap = mapsService.maps.randomElement()
        let mapViewModel = viewModel?.mapViewModel(at: randomMap.index)
        
        var previewData: Data?
        mapViewModel?.fetchMapPreviewPNGData { previewData = $0 }

        XCTAssertEqual(randomMap.element.identifier, viewModel?.identifierForMap(at: randomMap.index))
        XCTAssertEqual(randomMap.element.location, mapViewModel?.mapName)
        XCTAssertEqual(randomMap.element.imagePNGData, previewData)
    }

}
