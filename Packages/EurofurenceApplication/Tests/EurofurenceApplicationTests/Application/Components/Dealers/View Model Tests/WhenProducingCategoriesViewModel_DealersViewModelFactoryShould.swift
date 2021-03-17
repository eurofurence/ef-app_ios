import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenProducingCategoriesViewModel_DealersViewModelFactoryShould: XCTestCase {

    func testContainSameNumberOfCategoriesFromIndex() {
        let categories = [FakeDealerCategory(), FakeDealerCategory(), FakeDealerCategory()]
        let viewModel = prepareCategoriesViewModel(categories: categories)
        
        XCTAssertEqual(3, viewModel?.numberOfCategories)
    }
    
    func testProduceCategoryTitlesInGivenOrder() {
        let titles = ["Artwork", "Fursuit", "Zulu"]
        let categories = titles.map({ FakeDealerCategory(title: $0) })
        let viewModel = prepareCategoriesViewModel(categories: categories)
        
        XCTAssertEqual("Artwork", viewModel?.categoryViewModel(at: 0).title)
        XCTAssertEqual("Fursuit", viewModel?.categoryViewModel(at: 1).title)
        XCTAssertEqual("Zulu", viewModel?.categoryViewModel(at: 2).title)
    }
    
    func testPropogateCategoryActiveToInactiveState() {
        let category = FakeDealerCategory()
        category.transitionToActiveState()
        let viewModel = prepareCategoriesViewModel(categories: [category])
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
        let viewModel = prepareCategoriesViewModel(categories: [category])
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
        let viewModel = prepareCategoriesViewModel(categories: [category])
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        categoryViewModel?.toggleCategoryActiveState()
        
        XCTAssertTrue(category.isActive)
    }
    
    func testTogglingActiveStateWhileActiveTellsCategoryToBecomeInactive() {
        let category = FakeDealerCategory()
        category.transitionToActiveState()
        let viewModel = prepareCategoriesViewModel(categories: [category])
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        categoryViewModel?.toggleCategoryActiveState()
        
        XCTAssertFalse(category.isActive)
    }
    
    func testUpdateAvailableCategoriesWhenCollectionChanges() {
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [FakeDealerCategory]())
        let viewModel = prepareCategoriesViewModel(categoriesCollection: categoriesCollection)
        let category = FakeDealerCategory(title: "Updated Category")
        categoriesCollection.categories = [category]
        
        XCTAssertEqual(1, viewModel?.numberOfCategories)
        XCTAssertEqual("Updated Category", viewModel?.categoryViewModel(at: 0).title)
    }
    
    private func prepareCategoriesViewModel<T>(
        categories: [T]
    ) -> DealerCategoriesViewModel? where T: DealerCategory {
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: categories)
        return prepareCategoriesViewModel(categoriesCollection: categoriesCollection)
    }
    
    private func prepareCategoriesViewModel(
        categoriesCollection: DealerCategoriesCollection
    ) -> DealerCategoriesViewModel? {
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(service).build()
        
        return context.prepareCategoriesViewModel()
    }

}
