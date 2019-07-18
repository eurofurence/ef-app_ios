import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealersIndexCategoriesShould: XCTestCase {
    
    var context: EurofurenceSessionTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = EurofurenceSessionTestBuilder().build()
    }

    func testBeAdaptedFromResponse() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 1)
        
        let firstCategory = categories.category(at: 0)
        XCTAssertEqual(firstCategory.name, "Test")
    }
    
    func testBeActiveByDefault() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let category = categories.category(at: 0)
        
        let categoryObserver = CapturingDealerCategoryObserver()
        category.add(categoryObserver)
        
        XCTAssertEqual(.active, categoryObserver.state)
    }
    
    func testBeConsolidatedByName() {
        updateDealers([makeDealer(categories: "Test"), makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 1)
        XCTAssertEqual(categories.category(at: 0).name, "Test")
    }
    
    func testBeSortedAlphabetically() {
        updateDealers([makeDealer(categories: "C"), makeDealer(categories: "B"), makeDealer(categories: "A")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        
        XCTAssertEqual(categories.numberOfCategories, 3)
        XCTAssertEqual(categories.category(at: 0).name, "A")
        XCTAssertEqual(categories.category(at: 1).name, "B")
        XCTAssertEqual(categories.category(at: 2).name, "C")
    }
    
    func testRestrictIndexToDealersWithActiveCategory() {
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        updateDealers([firstDealer, secondDealer])
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
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        updateDealers([firstDealer, secondDealer])
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
        let firstDealer = makeDealer(categories: "A")
        let secondDealer = makeDealer(categories: "B")
        updateDealers([firstDealer, secondDealer])
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
    
    func testNotifyObserverWhenDeactivated() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let category = categories.category(at: 0)
        
        let categoryObserver = CapturingDealerCategoryObserver()
        category.add(categoryObserver)
        category.deactivate()
        
        XCTAssertEqual(.inactive, categoryObserver.state)
    }
    
    func testNotifyObserverWhenDeactivated_LateAddedObserver() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let category = categories.category(at: 0)
        
        let categoryObserver = CapturingDealerCategoryObserver()
        category.deactivate()
        category.add(categoryObserver)
        
        XCTAssertEqual(.inactive, categoryObserver.state)
    }
    
    func testNotifyObserverWhenReactivated() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let category = categories.category(at: 0)
        
        let categoryObserver = CapturingDealerCategoryObserver()
        category.add(categoryObserver)
        category.deactivate()
        category.activate()
        
        XCTAssertEqual(.active, categoryObserver.state)
    }
    
    func testNotifyObserverWhenCategoriesChange() {
        updateDealers([makeDealer(categories: "Test")])
        let index = context.dealersService.makeDealersIndex()
        let categories = index.availableCategories
        let observer = CapturingDealerCategoriesCollectionObserver()
        categories.add(observer)
        
        XCTAssertFalse(observer.toldCategoriesDidChange)

        updateDealers([makeDealer(categories: "Test"), makeDealer(categories: "Test 2")])
        
        XCTAssertTrue(observer.toldCategoriesDidChange)
        XCTAssertEqual(2, categories.numberOfCategories)
        XCTAssertEqual("Test", categories.category(at: 0).name)
        XCTAssertEqual("Test 2", categories.category(at: 1).name)
    }
    
    private func updateDealers(_ dealers: [DealerCharacteristics]) {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        characteristics.dealers.changed = dealers
        context.refreshLocalStore()
        context.simulateSyncSuccess(characteristics)
    }
    
    private func makeDealer(categories: String ...) -> DealerCharacteristics {
        var dealer = DealerCharacteristics.random
        dealer.categories = categories
        
        return dealer
    }

}
