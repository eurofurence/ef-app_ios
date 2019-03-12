//
//  WhenFetchingIconDataForDealerWithArtwork_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingIconDataForDealerWithArtwork_ApplicationShould: XCTestCase {

    func testReturnTheArtworkFromTheImageAPIForTheArtistThumbnailIdentifier() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.api.stubbedImage(for: dealer.artistThumbnailImageId)
        var artworkData: Data?
        context.dealersService.fetchIconPNGData(for: DealerIdentifier(dealer.identifier)) { artworkData = $0 }

        XCTAssertEqual(expected, artworkData)
    }

}
