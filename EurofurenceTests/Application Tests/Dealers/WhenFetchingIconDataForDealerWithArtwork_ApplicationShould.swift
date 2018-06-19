//
//  WhenFetchingIconDataForDealerWithArtwork_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingIconDataForDealerWithArtwork_ApplicationShould: XCTestCase {
    
    func testReturnTheArtworkFromTheImageAPIForTheArtistThumbnailIdentifier() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        let artistArtworkThumbnailID = String.random
        dealer.artistThumbnailImageId = artistArtworkThumbnailID
        syncResponse.dealers.changed = [dealer]
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.imageAPI.stubbedImage(for: artistArtworkThumbnailID)
        var artworkData: Data?
        context.application.fetchIconPNGData(for: Dealer2.Identifier(dealer.identifier)) { artworkData = $0 }
        
        XCTAssertEqual(expected, artworkData)
    }
    
}
