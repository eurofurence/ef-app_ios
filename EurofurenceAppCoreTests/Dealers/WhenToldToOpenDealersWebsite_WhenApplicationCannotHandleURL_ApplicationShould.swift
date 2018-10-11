//
//  WhenToldToOpenDealersWebsite_WhenApplicationCannotHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenToldToOpenDealersWebsite_WhenApplicationCannotHandleURL_ApplicationShould: XCTestCase {

    func testNotTellTheApplicationToOpenTheURL() {
        var dealer = APIDealer.random
        dealer.links = [APILink(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = UnhappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

    func testTellExternalContentHandlerToOpenTheURL() {
        var dealer = APIDealer.random
        dealer.links = [APILink(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = UnhappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        let externalContentHandler = CapturingExternalContentHandler()
        context.application.setExternalContentHandler(externalContentHandler)
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)
        let expected = URL(string: "https://www.eurofurence.org")!

        XCTAssertEqual(expected, externalContentHandler.capturedExternalContentURL)
    }

}
