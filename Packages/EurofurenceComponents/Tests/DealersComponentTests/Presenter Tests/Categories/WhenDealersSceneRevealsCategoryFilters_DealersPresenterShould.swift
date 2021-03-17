import EurofurenceApplication
import XCTest

class WhenDealersSceneRevealsCategoryFilters_DealersPresenterShould: XCTestCase {

    func testBindTheAvailableCategoriesToTheScene() {
        let aCategory = FakeDealerCategoryViewModel(title: "A")
        let bCategory = FakeDealerCategoryViewModel(title: "B")
        let cCategory = FakeDealerCategoryViewModel(title: "C")
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [aCategory, bCategory, cCategory])
        let viewModelFactory = FakeDealersViewModelFactory(
            viewModel: CapturingDealersViewModel.random,
            categoriesViewModel: categoriesViewModel
        )
        
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual("A", context.scene.filtersScene.boundFilterTitle(at: 0))
        XCTAssertEqual("B", context.scene.filtersScene.boundFilterTitle(at: 1))
        XCTAssertEqual("C", context.scene.filtersScene.boundFilterTitle(at: 2))
    }
    
    func testToggleCategoryActiveStateWhenComponentSelected() {
        let category = FakeDealerCategoryViewModel(title: "A")
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [category])
        let viewModelFactory = FakeDealersViewModelFactory(
            viewModel: CapturingDealersViewModel.random,
            categoriesViewModel: categoriesViewModel
        )
        
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        context.scene.filtersScene.selectComponent(at: 0)
        
        XCTAssertTrue(category.toldToToggleActiveState)
    }

}
