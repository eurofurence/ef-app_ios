@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenProducingCategoriesViewModel_DealersInteractorShould: XCTestCase {

    func testContainSameNumberOfCategoriesFromIndex() {
        let categories = [FakeDealerCategory(), FakeDealerCategory(), FakeDealerCategory()]
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: categories)
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        
        XCTAssertEqual(3, viewModel?.numberOfCategories)
    }
    
    func testProduceCategoryTitlesInGivenOrder() {
        let titles = ["Artwork", "Fursuit", "Zulu"]
        let categories = titles.map({ FakeDealerCategory(title: $0) })
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: categories)
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        
        XCTAssertEqual("Artwork", viewModel?.categoryViewModel(at: 0).title)
        XCTAssertEqual("Fursuit", viewModel?.categoryViewModel(at: 1).title)
        XCTAssertEqual("Zulu", viewModel?.categoryViewModel(at: 2).title)
    }
    
    func testAddingObserverToActiveCategoryTellsThemItsActive() {
        let category = FakeDealerCategory()
        category.transitionToActiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        let observer = CapturingDealerCategoryViewModelObserver()
        categoryViewModel?.add(observer)
        
        XCTAssertEqual(.active, observer.state)
    }
    
    func testAddingObserverToInactiveCategoryTellsThemItsInactive() {
        let category = FakeDealerCategory()
        category.transitionToInactiveState()
        let categoriesCollection = InMemoryDealerCategoriesCollection(categories: [category])
        let index = FakeDealersIndex(availableCategories: categoriesCollection)
        let service = FakeDealersService(index: index)
        let context = DealerInteractorTestBuilder().with(service).build()
        let viewModel = context.prepareCategoriesViewModel()
        let categoryViewModel = viewModel?.categoryViewModel(at: 0)
        let observer = CapturingDealerCategoryViewModelObserver()
        categoryViewModel?.add(observer)
        
        XCTAssertEqual(.inactive, observer.state)
    }

}

class CapturingDealerCategoryViewModelObserver: DealerCategoryViewModelObserver {
    
    enum State {
        case unset
        case active
        case inactive
    }
    
    private(set) var state: State = .unset
    
    func categoryDidEnterActiveState() {
        state = .active
    }
    
    func categoryDidEnterInactiveState() {
        state = .inactive
    }
    
}
