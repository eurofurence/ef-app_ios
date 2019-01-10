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

    var context: ApplicationTestBuilder.Context!
    var response: APISyncResponse!
    var dealer: APIDealer!
    var dealerData: ExtendedDealerData!

    override func setUp() {
        super.setUp()

        response = APISyncResponse.randomWithoutDeletions
        dealer = APIDealer.random
        dealer.links = nil
        dealer.twitterHandle = ""
        dealer.telegramHandle = ""
        dealer.aboutTheArtistText = ""
        dealer.aboutTheArtText = ""
        dealer.artPreviewCaption = ""
        response.dealers.changed = [dealer]
        context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let identifier = DealerIdentifier(dealer.identifier)
        context.dealersService.fetchExtendedDealerData(for: identifier) { self.dealerData = $0 }
    }

    func testProvideNilTwitterUsernameWhenEmptyHandleProvided() {
        XCTAssertNil(dealerData.twitterUsername)
    }

    func testProvideNilTelegramUsernameWhenEmptyHandleProvided() {
        XCTAssertNil(dealerData.telegramUsername)
    }

    func testProvideNilAboutTheArtistTextWhenEmptyDescriptionProvided() {
        XCTAssertNil(dealerData.aboutTheArtist)
    }

    func testProvideNilAboutTheArtDescriptionWhenEmptyDescriptionProvided() {
        XCTAssertNil(dealerData.aboutTheArt)
    }

    func testProvideNilAboutTheArtCaptionWhenEmptyCaptionProvided() {
        XCTAssertNil(dealerData.artPreviewCaption)
    }

}
