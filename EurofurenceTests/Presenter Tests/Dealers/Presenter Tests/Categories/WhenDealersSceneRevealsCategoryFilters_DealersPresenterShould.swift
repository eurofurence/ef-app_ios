@testable import Eurofurence
import XCTest

class FakeDealerCategoriesViewModel: DealerCategoriesViewModel {
    
    private let categories: [DealerCategoryViewModel]
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func categoryViewModel(at index: Int) -> DealerCategoryViewModel {
        return categories[index]
    }
    
    init(categories: [DealerCategoryViewModel] = []) {
        self.categories = categories
    }
    
}

class FakeDealerCategoryViewModel: DealerCategoryViewModel {
    
    let title: String
    private var isActive: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    func add(_ observer: DealerCategoryViewModelObserver) {
        if isActive {
            observer.categoryDidEnterActiveState(self)
        } else {
            observer.categoryDidEnterInactiveState(self)
        }
    }
    
    func enterActiveState() {
        isActive = true
    }
    
    func enterInactiveState() {
        isActive = false
    }
    
}

class WhenDealersSceneRevealsCategoryFilters_DealersPresenterShould: XCTestCase {

    func testBindTheAvailableCategoriesToTheScene() {
        let aCategory = FakeDealerCategoryViewModel(title: "A")
        let bCategory = FakeDealerCategoryViewModel(title: "B")
        let cCategory = FakeDealerCategoryViewModel(title: "C")
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [aCategory, bCategory, cCategory])
        let interactor = FakeDealersInteractor(viewModel: CapturingDealersViewModel.random, categoriesViewModel: categoriesViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual("A", context.scene.filtersScene.boundFilterTitle(at: 0))
        XCTAssertEqual("B", context.scene.filtersScene.boundFilterTitle(at: 1))
        XCTAssertEqual("C", context.scene.filtersScene.boundFilterTitle(at: 2))
    }

}
