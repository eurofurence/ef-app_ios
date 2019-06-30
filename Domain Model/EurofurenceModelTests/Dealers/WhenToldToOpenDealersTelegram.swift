import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersTelegram: XCTestCase {

    func testTellTheApplicationToOpenTheTelegramURLWithTheDealersHandle() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let urlOpener = CapturingURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTelegram()
        let expected = unwrap(URL(string: "https://t.me/")).appendingPathComponent(dealer.twitterHandle)

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

    func testNotTellTheApplicationToOpenTheTelegramURLWhenTheDealersHandleIsEmpty() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.telegramHandle = ""
        syncResponse.dealers.changed = [dealer]
        let urlOpener = CapturingURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openTelegram()

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
