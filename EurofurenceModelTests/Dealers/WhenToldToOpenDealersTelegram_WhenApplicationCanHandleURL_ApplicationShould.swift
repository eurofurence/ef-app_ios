//
//  WhenToldToOpenDealersTelegram_WhenApplicationCanHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersTelegram_WhenApplicationCanHandleURL_ApplicationShould: XCTestCase {

    func testTellTheApplicationToOpenTheTelegramURLWithTheDealersHandle() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer.Identifier(dealer.identifier)
        context.application.openTelegram(for: dealerIdentifier)
        let expected = URL(string: "https://t.me/")!.appendingPathComponent(dealer.twitterHandle)

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellTheApplicationToOpenTheTelegramURLWhenTheDealersHandleIsEmpty() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        dealer.telegramHandle = ""
        syncResponse.dealers.changed = [dealer]
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer.Identifier(dealer.identifier)
        context.application.openTelegram(for: dealerIdentifier)

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
