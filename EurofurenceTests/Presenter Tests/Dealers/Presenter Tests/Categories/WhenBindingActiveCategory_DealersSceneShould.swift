@testable import Eurofurence
import XCTest

class WhenBindingActiveCategory_DealersSceneShould: XCTestCase {

    func testShowCategoryActiveIndicator() {
        let activeCategory = FakeDealerCategoryViewModel(title: "A")
        activeCategory.enterActiveState()
        let categoriesViewModel = FakeDealerCategoriesViewModel(categories: [activeCategory])
        let interactor = FakeDealersInteractor(viewModel: CapturingDealersViewModel.random, categoriesViewModel: categoriesViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidRevealCategoryFilters()
        
        XCTAssertEqual(.visible, context.scene.filtersScene.visibilityForCategoryActiveIndicator(at: 0))
    }

}
