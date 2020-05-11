import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenProducingCategoriesViewModel_DealersViewModelFactoryShould: XCTestCase {

    func testContainSameNumberOfCategoriesFromIndex() {
        let categories = [FakeDealerCategory(), FakeDealerCategory(), FakeDealerCategory()]
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: categories)
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        
        XCTAssertEqual(3, viewModel?.numberOfCategories)
    }
    
    func testProduceCategoryTitlesInGivenOrder() {
        let titles = ["Artwork", "Fursuit", "Zulu"]
        let categories = titles.map({ FakeDealerCategory(title: $0) })
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: categories)
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        
        XCTAssertEqual("Artwork", viewModel?.categoryViewModel(at: 0).title)
        XCTAssertEqual("Fursuit", viewModel?.categoryViewModel(at: 1).title)
        XCTAssertEqual("Zulu", viewModel?.categoryViewModel(at: 2).title)
    }
    
    func testPropogateCategoryActiveToInactiveState() {
        let category = FakeDealerCategory()
        category.transitionToActiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        let observer = CapturingDealerCategoryViewModelObserver()
        categoryViewModel?.add(observer)
        
        XCTAssertEqual(.active, observer.state)
        
        category.transitionToInactiveState()
        
        XCTAssertEqual(.inactive, observer.state)
    }
    
    func testPropogateCategoryInactiveToActiveState() {
        let category = FakeDealerCategory()
        category.transitionToInactiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        let observer = CapturingDealerCategoryViewModelObserver()
        categoryViewModel?.add(observer)
        
        XCTAssertEqual(.inactive, observer.state)
        
        category.transitionToActiveState()
        
        XCTAssertEqual(.active, observer.state)
    }
    
    func testTogglingActiveStateWhileInactiveTellsCategoryToBecomeActive() {
        let category = FakeDealerCategory()
        category.transitionToInactiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        categoryViewModel?.toggleCategoryActiveState()
        
        XCTAssertTrue(category.isActive)
    }
    
    func testTogglingActiveStateWhileActiveTellsCategoryToBecomeInactive() {
        let category = FakeDealerCategory()
        category.transitionToActiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        categoryViewModel?.toggleCategoryActiveState()
        
        XCTAssertFalse(category.isActive)
    }
    
    func testUpdateAvailableCategoriesWhenCollectionChanges() {
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [FakeDealerCategory]())
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let category = FakeDealerCategory(title: "Updated Category")
        categoriesCollection.categories = [category]
        
        XCTAssertEqual(1, viewModel?.numberOfCategories)
        XCTAssertEqual("Updated Category", viewModel?.categoryViewModel(at: 0).title)
    }

}
