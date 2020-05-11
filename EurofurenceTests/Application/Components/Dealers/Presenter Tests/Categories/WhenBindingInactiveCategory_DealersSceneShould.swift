import Eurofurence
import XCTest

class WhenBindingInactiveCategory_DealersSceneShould: XCTestCase {

    func testHideCategoryActiveIndicator() {
        let activeCategory = FakeDealerCategoryViewModel(title: "A")
        activeCategory.enterInactiveState()
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [activeCategory])
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: CapturingDealersViewModel.random, categoriesViewModel: categoriesViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual(.hidden, context.scene.filtersScene.visibilityForCategoryActiveIndicator(at: 0))
    }

}
