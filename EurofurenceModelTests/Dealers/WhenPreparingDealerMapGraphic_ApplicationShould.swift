//
//  WhenPreparingDealerMapGraphic_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPreparingDealerMapGraphic_ApplicationShould: XCTestCase {

    func testProvideRenderedMapDataInExtendedData() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomDealer = syncResponse.dealers.changed.randomElement()
        var randomMap = syncResponse.maps.changed.randomElement()
        let dealerMapLink = MapCharacteristics.Entry.Link(type: .dealerDetail, name: .random, target: randomDealer.element.identifier)
        let dealerMapEntry = MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: .random, links: [dealerMapLink])
        randomMap.element.entries = [dealerMapEntry]
        syncResponse.maps.changed[randomMap.index] = randomMap.element
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let mapGraphic = context.api.stubbedImage(for: randomMap.element.imageIdentifier)!
        let renderedData = Data.random
        context.mapCoordinateRender.stub(renderedData, forGraphic: mapGraphic, atX: dealerMapEntry.x, y: dealerMapEntry.y, radius: dealerMapEntry.tapRadius)
        var extendedData: ExtendedDealerData?
        context.dealersService.fetchExtendedDealerData(for: DealerIdentifier(rawValue: randomDealer.element.identifier)!) { extendedData = $0 }

        XCTAssertEqual(renderedData, extendedData?.dealersDenMapLocationGraphicPNGData)
    }

}
