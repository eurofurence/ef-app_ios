import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_MapDetailViewModelFactoryShould: XCTestCase {

    func testPrepareViewModelWithTitleForSpecifiedMap() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        XCTAssertEqual(randomMap.element.location, viewModel?.mapName)
    }

    func testPrepareViewModelWithMapGraphicData() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        XCTAssertEqual(randomMap.element.imagePNGData, viewModel?.mapImagePNGData)
    }

}
