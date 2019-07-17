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
    
    func testRestrictIndexToDealersWithActiveCategory() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [firstDealer, secondDealer]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let aCategory = categories.category(at: 0)
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)
        aCategory.deactivate()
        
        DealerAssertion()
            .assertDealers(delegate.capturedAlphabetisedDealerGroups.first?.dealers, characterisedBy: [secondDealer])
    }
    
    func testRestrictIndexToDealersWithActiveCategory_LateAddedDelegate() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [firstDealer, secondDealer]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let aCategory = categories.category(at: 0)
        let delegate = CapturingDealersIndexDelegate()
        aCategory.deactivate()
        index.setDelegate(delegate)
        
        DealerAssertion()
            .assertDealers(delegate.capturedAlphabetisedDealerGroups.first?.dealers, characterisedBy: [secondDealer])
    }
    
    func testIncludeDealersInReactivatedCategories() {
        let context = EurofurenceSessionTestBuilder().build()
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = [firstDealer, secondDealer]
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let aCategory = categories.category(at: 0)
        let delegate = CapturingDealersIndexDelegate()
        aCategory.deactivate()
        aCategory.activate()
        index.setDelegate(delegate)
        
        let allDealers = delegate.capturedAlphabetisedDealerGroups.flatMap({ $0.dealers })
        
        DealerAssertion()
            .assertDealers(allDealers, characterisedBy: [firstDealer, secondDealer])
    }
    
    private func makeDealer(categories: String ...) -> DealerCharacteristics {
        var dealer = DealerCharacteristics.random
        dealer.categories = categories
        
        return dealer
    }

}
