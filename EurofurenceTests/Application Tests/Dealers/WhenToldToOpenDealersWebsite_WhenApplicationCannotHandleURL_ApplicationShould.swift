//
//  WhenToldToOpenDealersWebsite_WhenApplicationCannotHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UnhappyPathURLOpener: CapturingURLOpener {
    
    override func canOpen(_ url: URL) -> Bool {
        return false
    }
    
}

class CapturingExternalContentHandler: ExternalContentHandler {
    
    private(set) var capturedExternalContentURL: URL?
    func handleExternalContent(url: URL) {
        capturedExternalContentURL = url
    }
    
}

class WhenToldToOpenDealersWebsite_WhenApplicationCannotHandleURL_ApplicationShould: XCTestCase {
    
    func testNotTellTheApplicationToOpenTheURL() {
        var dealer = APIDealer.random
        dealer.links = [APILink(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = APISyncResponse.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = UnhappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
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
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
        context.application.openWebsite(for: dealerIdentifier)
        let expected = URL(string: "https://www.eurofurence.org")!
        
        XCTAssertEqual(expected, externalContentHandler.capturedExternalContentURL)
    }
    
}
