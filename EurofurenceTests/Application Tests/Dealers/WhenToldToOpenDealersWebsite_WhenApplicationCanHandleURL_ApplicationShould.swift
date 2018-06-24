//
//  WhenToldToOpenDealersWebsite_WhenApplicationCanHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)
        
        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }
    
}
