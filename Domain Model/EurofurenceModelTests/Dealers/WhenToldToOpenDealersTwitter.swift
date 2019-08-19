import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersTwitter: XCTestCase {

    func testTellTheApplicationToOpenTheTwitterURLWithTheDealersHandle() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = CapturingURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTwitter()
        let expected = URL(string: "https://twitter.com/").unsafelyUnwrapped.appendingPathComponent(dealer.twitterHandle)

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellTheApplicationToOpenTheTwitterURLWhenTheDealersHandleIsEmpty() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.twitterHandle = ""
        syncResponse.dealers.changed = [dealer]
        let urlOpener = CapturingURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTwitter()

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
