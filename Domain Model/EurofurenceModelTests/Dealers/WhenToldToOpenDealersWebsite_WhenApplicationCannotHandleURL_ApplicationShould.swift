import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenDealersWebsite_WhenApplicationCannotHandleURL_ApplicationShould: XCTestCase {

    func testNotTellTheApplicationToOpenTheURL() {
        var dealer = DealerCharacteristics.random
        dealer.links = [LinkCharacteristics(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")]
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let urlOpener = UnhappyPathURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openWebsite()

        XCTAssertNil(urlOpener.capturedURLToOpen)
    }

}
