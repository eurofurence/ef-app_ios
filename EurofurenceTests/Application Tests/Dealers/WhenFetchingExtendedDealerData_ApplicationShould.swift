//
//  WhenFetchingExtendedDealerData_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingExtendedDealerData_ApplicationShould: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var response: APISyncResponse!
    var randomDealer: APIDealer!
    var dealerData: ExtendedDealerData!
    
    override func setUp() {
        super.setUp()
        
        response = APISyncResponse.randomWithoutDeletions
        context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        randomDealer = response.dealers.changed.randomElement().element
        let identifier = Dealer2.Identifier(randomDealer.identifier)
        context.application.fetchExtendedDealerData(for: identifier) { self.dealerData = $0 }
    }
    
    func testUseTheSameAttributesFromTheShortFormDealerModel() {
        let index = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)
        let shortFormModel = delegate.capturedDealer(for: Dealer2.Identifier(randomDealer.identifier))
        
        XCTAssertEqual(shortFormModel?.preferredName, dealerData?.preferredName)
        XCTAssertEqual(shortFormModel?.alternateName, dealerData?.alternateName)
        XCTAssertEqual(shortFormModel?.isAttendingOnThursday, dealerData?.isAttendingOnThursday)
        XCTAssertEqual(shortFormModel?.isAttendingOnFriday, dealerData?.isAttendingOnFriday)
        XCTAssertEqual(shortFormModel?.isAttendingOnSaturday, dealerData?.isAttendingOnSaturday)
        XCTAssertEqual(shortFormModel?.isAfterDark, dealerData?.isAfterDark)
    }
    
    func testProvideTheArtistImageData() {
        let expected = context.imageAPI.stubbedImage(for: randomDealer.artistImageId)
        XCTAssertEqual(expected, dealerData?.artistImagePNGData)
    }
    
    func testProvideTheDealerCategories() {
        XCTAssertEqual(randomDealer.categories.sorted(), dealerData?.categories)
    }
    
    func testProvideTheShortDescription() {
        XCTAssertEqual(randomDealer.shortDescription, dealerData?.dealerShortDescription)
    }
    
    func testProvideTheNameOfTheFirstExternalLinkAsTheWebsiteName() {
        XCTAssertEqual(randomDealer.links?.first(where: { $0.fragmentType == .WebExternal })?.target, dealerData.websiteName)
    }
    
    func testProvideTheTwitterUsername() {
        XCTAssertEqual(randomDealer.twitterHandle, dealerData?.twitterUsername)
    }
    
    func testProvideTheTelegramUsername() {
        XCTAssertEqual(randomDealer.telegramHandle, dealerData?.telegramUsername)
    }
    
    func testProvideTheAboutTheArtistDescription() {
        XCTAssertEqual(randomDealer.aboutTheArtistText, dealerData?.aboutTheArtist)
    }
    
    func testProvideTheAboutTheArtDescription() {
        XCTAssertEqual(randomDealer.aboutTheArtText, dealerData?.aboutTheArt)
    }
    
    func testNotProvideTheArtPreviewImageData_DueToAppStoreRejectionForOffensiveContent() {
        XCTAssertNil(dealerData?.artPreviewImagePNGData)
    }
    
    func testNotProvideTheArtPreviewCaption_WhileWeDontProvideTheArtwork() {
        XCTAssertNil(dealerData?.artPreviewCaption)
    }
    
}
