//
//  WhenFetchingIconDataForDealerWithoutArtwork_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingIconDataForDealerWithoutArtwork_ApplicationShould: XCTestCase {
    
    func testInvokeTheFetchHandlerWithNilData() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        dealer.artistThumbnailImageId = nil
        syncResponse.dealers.changed = [dealer]
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        var invokedFetchHandlerWithNilData = false
        context.application.fetchIconPNGData(for: Dealer.Identifier(dealer.identifier)) { invokedFetchHandlerWithNilData = $0 == nil }
        
        XCTAssertTrue(invokedFetchHandlerWithNilData)
    }
    
}
