import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersTwitter_WhenApplicationCanHandleURL_ApplicationShould: XCTestCase {

    func testTellTheApplicationToOpenTheTwitterURLWithTheDealersHandle() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = HappyPathURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTwitter()
        let expected = unwrap(URL(string: "https://twitter.com/")).appendingPathComponent(dealer.twitterHandle)

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellTheApplicationToOpenTheTwitterURLWhenTheDealersHandleIsEmpty() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.twitterHandle = ""
        syncResponse.dealers.changed = [dealer]
        let urlOpener = HappyPathURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTwitter()

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
