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
        
        let firstCategory = categories.category(at: 0)
        XCTAssertEqual(firstCategory.name, "Test")
        XCTAssertTrue(firstCategory.isActive)
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
    
    func testBeSortedAlphabetically() {
        let context = EurofurenceSessionTestBuilder().build()
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [makeDealer(categories: "C"), makeDealer(categories: "B"), makeDealer(categories: "A")]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 3)
        XCTAssertEqual(categories.category(at: 0).name, "A")
        XCTAssertEqual(categories.category(at: 1).name, "B")
        XCTAssertEqual(categories.category(at: 2).name, "C")
    }
    
    private func makeDealer(categories: String ...) -> DealerCharacteristics {
        var dealer = DealerCharacteristics.random
        dealer.categories = categories
        
        return dealer
    }

}
