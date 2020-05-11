import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSearching_DealersViewModelFactoryShould: XCTestCase {

    func testChangeSearchTermToUsedInput() {
        let index = FakeDealersIndex()
        let dealersService = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var searchViewModel: DealersSearchViewModel?
        context.viewModelFactory.makeDealersSearchViewModel { searchViewModel = $0 }
        let searchTerm = String.random
        searchViewModel?.updateSearchResults(with: searchTerm)

        XCTAssertEqual(searchTerm, index.capturedSearchTerm)
    }

}
