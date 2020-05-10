@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneUpdatesSearchQuery_DealersPresenterShould: XCTestCase {

    func testTellTheSearchableViewModelToUpdateItsResults() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let viewModelFactory = FakeDealersViewModelFactory(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let query = String.random
        context.simulateSceneDidChangeSearchQuery(to: query)

        XCTAssertEqual(query, searchViewModel.capturedSearchQuery)
    }

}
