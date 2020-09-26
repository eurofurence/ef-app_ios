import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenProducingDealerViewModel_HappyPath_DealerDetailViewModelFactoryShould: XCTestCase {

    func testProduceExpectedNumberOfComponentsInOrder() {
        let visitor = visitViewModel()

        XCTAssertEqual(4, visitor.visitedComponents.count)
        XCTAssertTrue(visitor.visitedComponents[0] is DealerDetailSummaryViewModel)
        XCTAssertTrue(visitor.visitedComponents[1] is DealerDetailLocationAndAvailabilityViewModel)
        XCTAssertTrue(visitor.visitedComponents[2] is DealerDetailAboutTheArtistViewModel)
        XCTAssertTrue(visitor.visitedComponents[3] is DealerDetailAboutTheArtViewModel)
    }
    
    func testProduceExpectedSummaryAtIndexZero() {
        let dealerData = ExtendedDealerData.random
        let visitor = visitViewModel(dealerData: dealerData)
        let expected = DealerDetailSummaryViewModel(
            artistImagePNGData: dealerData.artistImagePNGData,
            title: dealerData.preferredName,
            subtitle: dealerData.alternateName,
            categories: dealerData.categories.joined(separator: ", "),
            shortDescription: dealerData.dealerShortDescription,
            website: dealerData.websiteName,
            twitterHandle: dealerData.twitterUsername,
            telegramHandle: dealerData.telegramUsername
        )

        XCTAssertEqual(expected, visitor.visitedSummary)
    }

    func testProduceExpectedLocationAndAvailability_WhenAlwaysAvailable_AndInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = true
        
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: nil,
                locatedInAfterDarkDealersDenMessage: .locatedWithinAfterDarkDen
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Friday", "Saturday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnFriday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday", "Saturday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnSaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday", "Friday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnFridayAndSaturdaySaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursdayAndSaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Friday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursdayAndFriday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Saturday"])
        assertDealerData(
            extendedDealerData,
            produces: DealerDetailLocationAndAvailabilityViewModel(
                title: .locationAndAvailability,
                mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                limitedAvailabilityWarning: limitedAvailabilityWarning,
                locatedInAfterDarkDealersDenMessage: nil
            )
        )
    }

    func testNotProduceLocationAndAvailabilityViewModelAtIndexOneWhenNoInformationAvailable() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.dealersDenMapLocationGraphicPNGData = nil
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        
        let visitor = visitViewModel(dealerData: extendedDealerData)

        XCTAssertNil(visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedAboutTheArtistComponentAtIndexTwo() {
        let dealerData = ExtendedDealerData.random
        let visitor = visitViewModel(dealerData: dealerData)
        let expected = DealerDetailAboutTheArtistViewModel(
            title: .aboutTheArtist,
            artistDescription: dealerData.aboutTheArtist.unsafelyUnwrapped
        )

        XCTAssertEqual(expected, visitor.visitedAboutTheArtist)
    }

    func testProduceAboutTheArtistComponentWithPlaceholderTextWhenCustomDescriptionMissingAtIndexTwo() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.aboutTheArtist = nil
        let visitor = visitViewModel(dealerData: extendedDealerData)
        let expected = DealerDetailAboutTheArtistViewModel(
            title: .aboutTheArtist,
            artistDescription: .aboutTheArtistPlaceholder
        )

        XCTAssertEqual(expected, visitor.visitedAboutTheArtist)
    }

    func testProduceExpectedAboutTheAboutTheArtComponentAtIndexThree() {
        let dealerData = ExtendedDealerData.random
        let visitor = visitViewModel(dealerData: dealerData)
        let expected = DealerDetailAboutTheArtViewModel(
            title: .aboutTheArt,
            aboutTheArt: dealerData.aboutTheArt,
            artPreviewImagePNGData: dealerData.artPreviewImagePNGData,
            artPreviewCaption: dealerData.artPreviewCaption
        )

        XCTAssertEqual(expected, visitor.visitedAboutTheArt)
    }

    func testNotProduceAboutTheAboutTheArtComponentWhenNoInformationHasBeenSupplied() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.aboutTheArt = nil
        extendedDealerData.artPreviewImagePNGData = nil
        extendedDealerData.artPreviewCaption = nil
        
        let visitor = visitViewModel(dealerData: extendedDealerData)
        
        XCTAssertNil(visitor.visitedAboutTheArt)
    }

    func testTellTheDealerServiceToOpenWebsiteForDealerWhenViewModelIsToldToOpenWebsite() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.openWebsite()

        XCTAssertTrue(context.dealer.websiteOpened)
    }

    func testTellTheDealerServiceToOpenTwitterForDealerWhenViewModelIsToldToOpenTwitter() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.openTwitter()

        XCTAssertTrue(context.dealer.twitterOpened)
    }

    func testTellTheDealerServiceToOpenTelegramForDealerWhenViewModelIsToldToOpenTelegram() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        viewModel?.openTelegram()

        XCTAssertTrue(context.dealer.telegramOpened)
    }
    
    func testSharingDealer() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()
        let sender = self
        viewModel?.shareDealer(self)
        
        XCTAssertTrue(sender === (context.shareService.sharedItemSender as AnyObject))
        XCTAssertEqual(DealerActivityItemSource(dealer: context.dealer), context.shareService.sharedItem as? DealerActivityItemSource)
    }
    
    private func visitViewModel(dealerData: ExtendedDealerData = .random) -> CapturingDealerDetailViewModelVisitor {
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: dealerData)
        let viewModel = context.makeViewModel()
        let visitor = CapturingDealerDetailViewModelVisitor()
        describeAllComponents(in: viewModel, to: visitor)
        
        return visitor
    }
    
    private func describeAllComponents(
        in viewModel: DealerDetailViewModel?,
        to visitor: DealerDetailViewModelVisitor
    ) {
        guard let viewModel = viewModel else { return }
        
        for idx in 0..<viewModel.numberOfComponents {
            viewModel.describeComponent(at: idx, to: visitor)
        }
    }
    
    private func assertDealerData(
        _ dealerData: ExtendedDealerData,
        produces expected: DealerDetailLocationAndAvailabilityViewModel,
        _ line: UInt = #line
    ) {
        let visitor = visitViewModel(dealerData: dealerData)
        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability, line: line)
    }

}
