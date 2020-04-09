import EurofurenceModel
import XCTest

class WhenDeletingDealer_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedDealer() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        let delegate = CapturingDealersIndexDelegate()
        let index = context.dealersService.makeDealersIndex()
        index.setDelegate(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let dealerToDelete = response.dealers.changed.randomElement()
        response.dealers.changed = response.dealers.changed.filter({ $0.identifier != dealerToDelete.element.identifier })
        let expected = Set(response.dealers.changed.map(\.identifier))
        response.dealers.changed.removeAll()
        response.dealers.deleted.append(dealerToDelete.element.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let allDealers = delegate.capturedAlphabetisedDealerGroups.map(\.dealers).reduce([], +)
        let actual = Set(allDealers.map(\.identifier.rawValue))

        XCTAssertEqual(expected, actual,
                       "Should have removed dealer \(dealerToDelete.element.identifier)")
    }

}
