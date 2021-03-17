import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenToldToOpenDealersWebsite: XCTestCase {

    func testTellTheApplicationToOpenTheURL() {
        var dealer = DealerCharacteristics.random
        dealer.links = [
            LinkCharacteristics(name: .random, fragmentType: .WebExternal, target: "https://www.eurofurence.org")
        ]
        
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        syncResponse.dealers.changed = [dealer]
        let expected = URL(string: "https://www.eurofurence.org").unsafelyUnwrapped
        let urlOpener = CapturingURLOpener()
        let context = EurofurenceSessionTestBuilder().with(urlOpener).build()
        context.performSuccessfulSync(response: syncResponse)
        let dealerIdentifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: dealerIdentifier)
        entity?.openWebsite()

        XCTAssertEqual(expected, urlOpener.capturedURLToOpen)
    }

}
