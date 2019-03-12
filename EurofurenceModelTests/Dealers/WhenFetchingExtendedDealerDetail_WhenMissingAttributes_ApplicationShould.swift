//
//  WhenFetchingExtendedDealerDetail_WhenMissingAttributes_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingExtendedDealerDetail_WhenMissingAttributes_ApplicationShould: XCTestCase {

    func testConvertEmptyStringAttributesIntoNils() {
        var response = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.links = nil
        dealer.twitterHandle = ""
        dealer.telegramHandle = ""
        dealer.aboutTheArtistText = ""
        dealer.aboutTheArtText = ""
        dealer.artPreviewCaption = ""
        response.dealers.changed = [dealer]
        let context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let identifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: identifier)
        var dealerData: ExtendedDealerData?
        entity?.fetchExtendedDealerData { dealerData = $0 }
        
        XCTAssertNotNil(dealerData)
        XCTAssertNil(dealerData?.twitterUsername)
        XCTAssertNil(dealerData?.telegramUsername)
        XCTAssertNil(dealerData?.aboutTheArtist)
        XCTAssertNil(dealerData?.aboutTheArt)
        XCTAssertNil(dealerData?.artPreviewCaption)
    }

}
