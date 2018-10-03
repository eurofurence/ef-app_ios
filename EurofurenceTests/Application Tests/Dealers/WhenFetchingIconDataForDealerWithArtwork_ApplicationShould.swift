//
//  WhenFetchingIconDataForDealerWithArtwork_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenFetchingIconDataForDealerWithArtwork_ApplicationShould: XCTestCase {
    
    func testReturnTheArtworkFromTheImageAPIForTheArtistThumbnailIdentifier() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.imageAPI.stubbedImage(for: dealer.artistThumbnailImageId)
        var artworkData: Data?
        context.application.fetchIconPNGData(for: Dealer2.Identifier(dealer.identifier)) { artworkData = $0 }
        
        XCTAssertEqual(expected, artworkData)
    }
    
}
