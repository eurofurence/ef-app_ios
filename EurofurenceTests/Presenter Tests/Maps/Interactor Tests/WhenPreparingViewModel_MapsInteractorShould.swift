@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_MapsInteractorShould: XCTestCase {

    func testAdaptNumberOfMapsFromServiceIntoMapsCount() {
        let mapsService = FakeMapsService()
        let interactor = DefaultMapsInteractor(mapsService: mapsService)
        var viewModel: MapsViewModel?
        interactor.makeMapsViewModel { viewModel = $0 }

        XCTAssertEqual(mapsService.maps.count, viewModel?.numberOfMaps)
    }

    func testAdaptMapNamesIntoMapViewModel() {
        let mapsService = FakeMapsService()
        let interactor = DefaultMapsInteractor(mapsService: mapsService)
        var viewModel: MapsViewModel?
        interactor.makeMapsViewModel { viewModel = $0 }
        let randomMap = mapsService.maps.randomElement()
        let mapViewModel = viewModel?.mapViewModel(at: randomMap.index)

        XCTAssertEqual(randomMap.element.location, mapViewModel?.mapName)
    }

    func testAdaptMapDataIntoPreview() {
        let mapsService = FakeMapsService()
        let interactor = DefaultMapsInteractor(mapsService: mapsService)
        var viewModel: MapsViewModel?
        interactor.makeMapsViewModel { viewModel = $0 }
        let randomMap = mapsService.maps.randomElement()
        let mapViewModel = viewModel?.mapViewModel(at: randomMap.index)
        var previewData: Data?
        mapViewModel?.fetchMapPreviewPNGData { previewData = $0 }

        XCTAssertEqual(randomMap.element.imagePNGData, previewData)
    }

    func testExposeIdentifierForSpecifiedMap() {
        let mapsService = FakeMapsService()
        let interactor = DefaultMapsInteractor(mapsService: mapsService)
        var viewModel: MapsViewModel?
        interactor.makeMapsViewModel { viewModel = $0 }
        let randomMap = mapsService.maps.randomElement()
        let identifier = viewModel?.identifierForMap(at: randomMap.index)

        XCTAssertEqual(randomMap.element.identifier, identifier)
    }

}
