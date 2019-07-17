import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealersIndexCategoriesShould: XCTestCase {

    func testBeAdaptedFromResponse() {
        let context = EurofurenceSessionTestBuilder().build()
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [makeDealer(categories: "Test")]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 1)
        XCTAssertEqual(categories.category(at: 0).name, "Test")
    }
    
    func testBeConsolidatedByName() {
        let context = EurofurenceSessionTestBuilder().build()
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [makeDealer(categories: "Test"), makeDealer(categories: "Test")]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 1)
        XCTAssertEqual(categories.category(at: 0).name, "Test")
    }
    
    private func makeDealer(categories: String ...) -> DealerCharacteristics {
        var dealer = DealerCharacteristics.random
        dealer.categories = categories
        
        return dealer
    }

}
