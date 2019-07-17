import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealersIndexCategoriesShould: XCTestCase {

    func testBeAdaptedFromResponse() {
        let context = EurofurenceSessionTestBuilder().build()
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.categories = ["Test Category"]
        characteristics.dealers.changed = [dealer]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 1)
        XCTAssertEqual(categories.category(at: 0).name, "Test Category")
    }

}
