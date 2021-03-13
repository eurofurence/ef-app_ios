import EurofurenceModel
import XCTest

class WhenPreparingDealerMapGraphic_ApplicationShould: XCTestCase {

    func testProvideRenderedMapDataInExtendedData() throws {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDealer = syncResponse.dealers.changed.randomElement()
        var randomMap = syncResponse.maps.changed.randomElement()
        let dealerMapLink = MapCharacteristics.Entry.Link(
            type: .dealerDetail,
            name: .random,
            target: randomDealer.element.identifier
        )
        
        let dealerMapEntry = MapCharacteristics.Entry(
            identifier: .random,
            x: .random,
            y: .random,
            tapRadius: .random,
            links: [dealerMapLink]
        )
        
        randomMap.element.entries = [dealerMapEntry]
        syncResponse.maps.changed[randomMap.index] = randomMap.element
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let mapGraphic = try XCTUnwrap(context.api.stubbedImage(
            for: randomMap.element.imageIdentifier,
            availableImages: syncResponse.images.changed
        ))
        
        let renderedData = Data.random
        context.mapCoordinateRender.stub(
            renderedData,
            forGraphic: mapGraphic,
            atX: dealerMapEntry.x,
            y: dealerMapEntry.y,
            radius: dealerMapEntry.tapRadius
        )
        
        let dealerEntity = context.dealersService.fetchDealer(for: DealerIdentifier(randomDealer.element.identifier))
        var extendedData: ExtendedDealerData?
        dealerEntity?.fetchExtendedDealerData { extendedData = $0 }

        XCTAssertEqual(renderedData, extendedData?.dealersDenMapLocationGraphicPNGData)
    }

}
