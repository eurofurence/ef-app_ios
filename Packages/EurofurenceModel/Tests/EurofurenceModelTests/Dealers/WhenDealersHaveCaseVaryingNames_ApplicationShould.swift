import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDealersHaveCaseVaryingNames_ApplicationShould: XCTestCase {

    func testGroupThemTogetherUsingTheCapitalForm() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstDealer = DealerCharacteristics.random
        firstDealer.displayName = "Barry"
        var secondDealer = DealerCharacteristics.random
        secondDealer.displayName = "barry"
        syncResponse.dealers.changed = [firstDealer, secondDealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let group = delegate.capturedAlphabetisedDealerGroups.first

        XCTAssertEqual("B", group?.indexingString)
        XCTAssertEqual(2, group?.dealers.count)
    }
    
    func testSortIgnoringCase() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstDealer = DealerCharacteristics.random
        firstDealer.displayName = "ANGO76"
        var secondDealer = DealerCharacteristics.random
        secondDealer.displayName = "Aaargh"
        syncResponse.dealers.changed = [firstDealer, secondDealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let group = delegate.capturedAlphabetisedDealerGroups.first
        
        XCTAssertEqual("Aaargh", group?.dealers[0].preferredName)
        XCTAssertEqual("ANGO76", group?.dealers[1].preferredName)
    }

}
