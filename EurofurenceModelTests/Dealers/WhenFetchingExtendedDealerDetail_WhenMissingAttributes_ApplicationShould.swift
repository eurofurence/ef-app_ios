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
    var response: ModelCharacteristics!
    var dealer: DealerCharacteristics!
    var dealerData: ExtendedDealerData!

    override func setUp() {
        super.setUp()

        response = ModelCharacteristics.randomWithoutDeletions
        dealer = DealerCharacteristics.random
        dealer.links = nil
        dealer.twitterHandle = ""
        dealer.telegramHandle = ""
        dealer.aboutTheArtistText = ""
        dealer.aboutTheArtText = ""
        dealer.artPreviewCaption = ""
        response.dealers.changed = [dealer]
        context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
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
