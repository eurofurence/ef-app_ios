import EurofurenceModel
import XCTest

class WhenObservingDealersIndexBeforeSyncOccurs_ApplicationShould: XCTestCase {

    func testTellTheIndexDelegateChangedToEmptyGroups() {
        let context = EurofurenceSessionTestBuilder().build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)

        XCTAssertTrue(delegate.toldAlphabetisedDealersDidChangeToEmptyValue)
    }

}
