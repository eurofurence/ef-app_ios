import EurofurenceModel
import XCTest

class WhenFetchingIconDataForDealerWithoutArtwork_ApplicationShould: XCTestCase {

    func testInvokeTheFetchHandlerWithNilData() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.artistThumbnailImageId = nil
        syncResponse.dealers.changed = [dealer]
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        var invokedFetchHandlerWithNilData = false
        let entity = context.dealersService.fetchDealer(for: DealerIdentifier(dealer.identifier))
        entity?.fetchIconPNGData { invokedFetchHandlerWithNilData = $0 == nil }

        XCTAssertTrue(invokedFetchHandlerWithNilData)
    }

}
