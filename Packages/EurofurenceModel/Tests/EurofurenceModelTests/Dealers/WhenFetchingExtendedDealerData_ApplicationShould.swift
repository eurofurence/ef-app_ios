import EurofurenceModel
import XCTest

class WhenFetchingExtendedDealerData_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var response: ModelCharacteristics!
    var randomDealer: DealerCharacteristics!
    var dealerData: ExtendedDealerData!

    override func setUp() {
        super.setUp()

        response = ModelCharacteristics.randomWithoutDeletions
        context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        randomDealer = response.dealers.changed.randomElement().element
        let identifier = DealerIdentifier(randomDealer.identifier)
        let dealerEntity = context.dealersService.fetchDealer(for: identifier)
        dealerEntity?.fetchExtendedDealerData { self.dealerData = $0 }
    }

    func testUseTheSameAttributesFromTheShortFormDealerModel() {
        let index = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)
        let shortFormModel = delegate.capturedDealer(for: DealerIdentifier(randomDealer.identifier))

        XCTAssertEqual(shortFormModel?.preferredName, dealerData?.preferredName)
        XCTAssertEqual(shortFormModel?.alternateName, dealerData?.alternateName)
        XCTAssertEqual(shortFormModel?.isAttendingOnThursday, dealerData?.isAttendingOnThursday)
        XCTAssertEqual(shortFormModel?.isAttendingOnFriday, dealerData?.isAttendingOnFriday)
        XCTAssertEqual(shortFormModel?.isAttendingOnSaturday, dealerData?.isAttendingOnSaturday)
        XCTAssertEqual(shortFormModel?.isAfterDark, dealerData?.isAfterDark)
    }

    func testProvideTheArtistImageData() {
        let expected = context.api.stubbedImage(
            for: randomDealer.artistImageId,
            availableImages: response.images.changed
        )
        
        XCTAssertEqual(expected, dealerData?.artistImagePNGData)
    }

    func testProvideTheArtPreviewImageData() {
        let expected = context.api.stubbedImage(
            for: randomDealer.artPreviewImageId,
            availableImages: response.images.changed)
        
        XCTAssertEqual(expected, dealerData?.artPreviewImagePNGData)
    }

    func testProvideTheDealerCategories() {
        XCTAssertEqual(randomDealer.categories.sorted(), dealerData?.categories)
    }

    func testProvideTheShortDescription() {
        XCTAssertEqual(randomDealer.shortDescription, dealerData?.dealerShortDescription)
    }

    func testProvideTheNameOfTheFirstExternalLinkAsTheWebsiteName() {
        XCTAssertEqual(
            randomDealer.links?.first(where: { $0.fragmentType == .WebExternal })?.target,
            dealerData.websiteName
        )
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

    func testProvideTheArtPreviewCaption() {
        XCTAssertEqual(randomDealer.artPreviewCaption, dealerData?.artPreviewCaption)
    }

}
