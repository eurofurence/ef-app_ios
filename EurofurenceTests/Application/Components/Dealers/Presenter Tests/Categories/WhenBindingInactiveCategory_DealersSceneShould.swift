import Eurofurence
import XCTest

class WhenBindingInactiveCategory_DealersSceneShould: XCTestCase {

    func testHideCategoryActiveIndicator() {
        let inactiveCategory = FakeDealerCategoryViewModel(title: "A")
        inactiveCategory.enterInactiveState()
        
        assertCategoryActiveVisibility(.hidden, forCategory: inactiveCategory)
    }
    
    func testShowCategoryActiveIndicator() {
        let activeCategory = FakeDealerCategoryViewModel(title: "A")
        activeCategory.enterActiveState()
        
        assertCategoryActiveVisibility(.visible, forCategory: activeCategory)
    }
    
    private func assertCategoryActiveVisibility(
        _ expected: VisibilityState,
        forCategory category: DealerCategoryViewModel,
        _ line: UInt = #line
    ) {
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [category])
        let viewModelFactory = FakeDealersViewModelFactory(
            viewModel: CapturingDealersViewModel.random,
            categoriesViewModel: categoriesViewModel
        )
        
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual(
            expected,
            context.scene.filtersScene.visibilityForCategoryActiveIndicator(at: 0),
            line: line
        )
    }

}
