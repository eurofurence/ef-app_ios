//
//  WhenToldToOpenDealersTwitter_WhenApplicationCannotHandleURL_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenToldToOpenDealersTwitter_WhenApplicationCannotHandleURL_ApplicationShould: XCTestCase {
    
    func testTellExternalContentHandlerToOpenTheWebBasedTwitterPageForTheUser() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = UnhappyPathURLOpener()
        let context = ApplicationTestBuilder().with(urlOpener).build()
        let externalContentHandler = CapturingExternalContentHandler()
        context.application.setExternalContentHandler(externalContentHandler)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealerIdentifier = Dealer2.Identifier(dealer.identifier)
        context.application.openTwitter(for: dealerIdentifier)
        let expected = URL(string: "https://twitter.com/")!.appendingPathComponent(dealer.twitterHandle)
        
        XCTAssertEqual(expected, externalContentHandler.capturedExternalContentURL)
    }
    
}
