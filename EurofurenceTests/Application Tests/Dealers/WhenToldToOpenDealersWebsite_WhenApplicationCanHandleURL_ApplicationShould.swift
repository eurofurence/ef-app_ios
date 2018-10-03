//
//  WhenToldToOpenDealersWebsite_WhenApplicationCanHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class HappyPathURLOpener: CapturingURLOpener {
    
    override func canOpen(_ url: URL) -> Bool {
        return true
    }
    
}

class WhenToldToOpenDealersWebsite_WhenApplicationCanHandleURL_ApplicationShould: XCTestCase {
    
    func testTellTheApplicationToOpenTheURL() {
        var dealer = APIDealer.random
        dealer.links = [APILink(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let expected = URL(string: "https://www.eurofurence.org")!
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)
        
        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }
    
    func testNotTellExternalContentHandlerToOpenTheURL() {
        var dealer = APIDealer.random
        dealer.links = [APILink(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = HappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        let externalContentHandler = CapturingExternalContentHandler()
        context.application.setExternalContentHandler(externalContentHandler)
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)
        
        XCTAssertNil(externalContentHandler.capturedExternalContentURL)
    }
    
}
