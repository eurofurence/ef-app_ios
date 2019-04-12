import EurofurenceModel
import XCTest

class WhenFetchingMapImageData_ApplicationShould: XCTestCase {

    func testReturnTheDataForTheMapsImageIdentifier() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let randomMap = syncResponse.maps.changed.randomElement()
        var mapImageData: Data?
        let entity = context.mapsService.fetchMap(for: MapIdentifier(randomMap.element.identifier))
        entity?.fetchImagePNGData { mapImageData = $0 }
        let imageEntity = context.imageRepository.loadImage(identifier: randomMap.element.imageIdentifier)

        XCTAssertEqual(imageEntity?.pngImageData, mapImageData)
    }

}
