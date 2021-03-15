import EurofurenceModel
import XCTest

class DealersRemoveAllBeforeInsertTests: XCTestCase {

    func testShouldRemoveAllDealersWhenToldTo() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.dealers.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let index = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerGroups,
                                          fromDealerCharacteristics: subsequentResponse.dealers.changed).assertGroups()
    }

}
