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

}
