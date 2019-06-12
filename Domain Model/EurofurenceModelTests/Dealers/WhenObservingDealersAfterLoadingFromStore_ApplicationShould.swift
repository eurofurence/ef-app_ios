import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenObservingDealersAfterLoadingFromStore_ApplicationShould: XCTestCase {

    func testUpdateTheDelegateWithDealersGroupedByDisplayName() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerGroups,
                                          fromDealerCharacteristics: syncResponse.dealers.changed).assertGroups()
    }

}
