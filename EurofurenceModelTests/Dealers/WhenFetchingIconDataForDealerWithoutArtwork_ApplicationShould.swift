//
//  WhenFetchingIconDataForDealerWithoutArtwork_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingIconDataForDealerWithoutArtwork_ApplicationShould: XCTestCase {

    func testInvokeTheFetchHandlerWithNilData() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.artistThumbnailImageId = nil
        syncResponse.dealers.changed = [dealer]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        var invokedFetchHandlerWithNilData = false
        context.dealersService.fetchIconPNGData(for: DealerIdentifier(dealer.identifier)) { invokedFetchHandlerWithNilData = $0 == nil }

        XCTAssertTrue(invokedFetchHandlerWithNilData)
    }

}
