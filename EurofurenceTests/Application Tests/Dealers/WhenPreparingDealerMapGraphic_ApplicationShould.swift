//
//  WhenPreparingDealerMapGraphic_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingDealerMapGraphic_ApplicationShould: XCTestCase {
    
    func testProvideRenderedMapDataInExtendedData() {
        var map = APIMap.random
        let dealerIdentifier = Dealer2.Identifier.random
        let dealerMapLink = APIMap.Entry.Link(type: .dealerDetail, name: .random, target: dealerIdentifier.rawValue)
        let dealerMapEntry = APIMap.Entry(x: .random, y: .random, tapRadius: .random, links: [dealerMapLink])
        map.entries = [dealerMapEntry]
        var dealer = APIDealer.random
        dealer.identifier = dealerIdentifier.rawValue
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.maps.changed = [map]
        syncResponse.dealers.changed = [dealer]
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let mapGraphic = context.imageAPI.stubbedImage(for: map.imageIdentifier)!
        let renderedData = Data.random
        context.mapCoordinateRender.stub(renderedData, forGraphic: mapGraphic, atX: dealerMapEntry.x, y: dealerMapEntry.y, radius: dealerMapEntry.tapRadius)
        var extendedData: ExtendedDealerData?
        context.application.fetchExtendedDealerData(for: dealerIdentifier) { extendedData = $0 }
        
        XCTAssertEqual(renderedData, extendedData?.dealersDenMapLocationGraphicPNGData)
    }
    
}
