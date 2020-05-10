@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenProducingDealerViewModel_HappyPath_DealerDetailViewModelFactoryShould: XCTestCase {

    func testProduceExpectedNumberOfComponents() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let viewModel = context.makeViewModel()

        XCTAssertEqual(4, viewModel?.numberOfComponents)
    }

    func testProduceExpectedSummaryAtIndexZero() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let dealerData = context.dealerData
        let viewModel = context.makeViewModel()
        let expected = DealerDetailSummaryViewModel(artistImagePNGData: dealerData.artistImagePNGData,
                                                    title: dealerData.preferredName,
                                                    subtitle: dealerData.alternateName,
                                                    categories: dealerData.categories.joined(separator: ", "),
                                                    shortDescription: dealerData.dealerShortDescription,
                                                    website: dealerData.websiteName,
                                                    twitterHandle: dealerData.twitterUsername,
                                                    telegramHandle: dealerData.telegramUsername)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 0, to: visitor)

        XCTAssertEqual(expected, visitor.visitedSummary)
    }

    func testProduceExpectedLocationAndAvailability_WhenAlwaysAvailable_AndInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = true
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: nil,
                                                                    locatedInAfterDarkDealersDenMessage: .locatedWithinAfterDarkDen)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Friday", "Saturday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnFriday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday", "Saturday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnSaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday", "Friday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnFridayAndSaturdaySaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Thursday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursdayAndSaturday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = false
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Friday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursdayAndFriday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = false
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()

        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Saturday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: extendedDealerData.dealersDenMapLocationGraphicPNGData,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }

    func testNotProduceLocationAndAvailabilityViewModelAtIndexOneWhenNoInformationAvailable() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.dealersDenMapLocationGraphicPNGData = nil
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)

        XCTAssertNil(visitor.visitedLocationAndAvailability)
    }

    func testProduceExpectedAboutTheArtistComponentAtIndexTwo() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let dealerData = context.dealerData
        let viewModel = context.makeViewModel()
        let expected = DealerDetailAboutTheArtistViewModel(title: .aboutTheArtist,
                                                           artistDescription: dealerData.aboutTheArtist.unsafelyUnwrapped)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 2, to: visitor)

        XCTAssertEqual(expected, visitor.visitedAboutTheArtist)
    }

    func testProduceAboutTheArtistComponentWithPlaceholderTextWhenCustomDescriptionMissingAtIndexTwo() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.aboutTheArtist = nil
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        let expected = DealerDetailAboutTheArtistViewModel(title: .aboutTheArtist,
                                                           artistDescription: .aboutTheArtistPlaceholder)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 2, to: visitor)

        XCTAssertEqual(expected, visitor.visitedAboutTheArtist)
    }

    func testProduceExpectedAboutTheAboutTheArtComponentAtIndexThree() {
        let context = DealerDetailViewModelFactoryTestBuilder().build()
        let dealerData = context.dealerData
        let viewModel = context.makeViewModel()
        let expected = DealerDetailAboutTheArtViewModel(title: .aboutTheArt,
                                                        aboutTheArt: dealerData.aboutTheArt,
                                                        artPreviewImagePNGData: dealerData.artPreviewImagePNGData,
                                                        artPreviewCaption: dealerData.artPreviewCaption)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 3, to: visitor)

        XCTAssertEqual(expected, visitor.visitedAboutTheArt)
    }

    func testNotProduceAboutTheAboutTheArtComponentWhenNoInformationHasBeenSupplied() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.aboutTheArt = nil
        extendedDealerData.artPreviewImagePNGData = nil
        extendedDealerData.artPreviewCaption = nil
        let context = DealerDetailViewModelFactoryTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 3, to: visitor)

        XCTAssertNil(visitor.visitedAboutTheArt)
        XCTAssertEqual(3, viewModel?.numberOfComponents)
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
        XCTAssertEqual(context.dealer.shareableURL, (context.shareService.sharedItem as? URL))
    }

}