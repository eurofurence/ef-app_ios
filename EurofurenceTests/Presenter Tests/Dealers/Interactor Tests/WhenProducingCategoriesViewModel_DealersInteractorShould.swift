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

}
