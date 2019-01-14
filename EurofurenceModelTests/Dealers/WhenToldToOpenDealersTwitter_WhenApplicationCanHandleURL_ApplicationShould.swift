//
//  WhenToldToOpenDealersTwitter_WhenApplicationCanHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersTwitter_WhenApplicationCanHandleURL_ApplicationShould: XCTestCase {

    func testTellTheApplicationToOpenTheTwitterURLWithTheDealersHandle() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        context.dealersService.openTwitter(for: dealerIdentifier)
        let expected = URL(string: "https://twitter.com/")!.appendingPathComponent(dealer.twitterHandle)

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellTheApplicationToOpenTheTwitterURLWhenTheDealersHandleIsEmpty() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.twitterHandle = ""
        syncResponse.dealers.changed = [dealer]
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        context.dealersService.openTwitter(for: dealerIdentifier)

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
