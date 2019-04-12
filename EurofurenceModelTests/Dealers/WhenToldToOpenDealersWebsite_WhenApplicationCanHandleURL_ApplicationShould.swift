import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersWebsite_WhenApplicationCanHandleURL_ApplicationShould: XCTestCase {

    func testTellTheApplicationToOpenTheURL() {
        var dealer = DealerCharacteristics.random
        dealer.links = [LinkCharacteristics(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let expected = URL(string: "https://www.eurofurence.org")!
        let urlOpener = HappyPathURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openWebsite()

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellExternalContentHandlerToOpenTheURL() {
        var dealer = DealerCharacteristics.random
        dealer.links = [LinkCharacteristics(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = HappyPathURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        let externalContentHandler = CapturingExternalContentHandler()
        context.contentLinksService.setExternalContentHandler(externalContentHandler)
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openWebsite()

        XCTAssertNil(externalContentHandler.capturedExternalContentURL)
    }

}
