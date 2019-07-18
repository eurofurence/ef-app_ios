@testable import Eurofurence
import XCTest

class FakeDealerCategoriesViewModel: DealerCategoriesViewModel {
    
    private let categories: [DealerCategoryViewModel]
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    init(categories: [DealerCategoryViewModel] = []) {
        self.categories = categories
    }
    
}

class FakeDealerCategoryViewModel: DealerCategoryViewModel {
    
    let title: String
    
    init(title: String) {
        self.title = title
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
        
        XCTAssertEqual(categoriesViewModel.numberOfCategories, context.scene.filtersScene.boundNumberOfCategories)
    }

}
