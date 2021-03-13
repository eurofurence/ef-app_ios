import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_MapDetailViewModelFactoryShould: XCTestCase {

    func testPrepareViewModelWithMapModel() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        XCTAssertEqual(randomMap.element.location, viewModel?.mapName)
        XCTAssertEqual(randomMap.element.imagePNGData, viewModel?.mapImagePNGData)
    }

}
