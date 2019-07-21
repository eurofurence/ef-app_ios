@testable import Eurofurence
import XCTest

class WhenBindingInactiveCategory_DealersSceneShould: XCTestCase {

    func testHideCategoryActiveIndicator() {
        let activeCategory = FakeDealerCategoryViewModel(title: "A")
        activeCategory.enterInactiveState()
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [activeCategory])
        let interactor = FakeDealersInteractor(viewModel: CapturingDealersViewModel.random, categoriesViewModel: categoriesViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual(.hidden, context.scene.filtersScene.visibilityForCategoryActiveIndicator(at: 0))
    }

}
