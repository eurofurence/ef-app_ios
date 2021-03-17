import DealersComponent
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDealersIndexProducesNewSearchResults_DealersViewModelFactoryShould: XCTestCase {

    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let index = FakeDealersIndex()
        let modelDealers = index.alphabetisedDealersSearchResult
        let expected = modelDealers.map(\.indexingString)
        let dealersService = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var searchViewModel: DealersSearchViewModel?
        context.viewModelFactory.makeDealersSearchViewModel { searchViewModel = $0 }
        let delegate = CapturingDealersSearchViewModelDelegate()
        searchViewModel?.setSearchResultsDelegate(delegate)
        let actual = delegate.capturedSearchResults.map(\.title)

        XCTAssertEqual(expected, actual)
    }

}
