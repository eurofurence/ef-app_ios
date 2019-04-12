import EurofurenceModel
import XCTest

class WhenObservingDealersIndexThenSyncOccurs_ApplicationShould: XCTestCase {

    func testUpdateTheDelegateWithDealersGroupedByDisplayName() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerGroups,
                                          fromDealerCharacteristics: syncResponse.dealers.changed).assertGroups()
    }

}
