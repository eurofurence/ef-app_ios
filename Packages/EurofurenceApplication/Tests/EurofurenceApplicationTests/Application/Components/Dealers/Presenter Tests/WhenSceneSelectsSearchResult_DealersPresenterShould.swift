import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsSearchResult_DealersPresenterShould: XCTestCase {

    func testTellTheModuleDelegateTheDealerIdentifierForTheSearchResultIndexPathWasSelected() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let identifier = DealerIdentifier.random
        let indexPath = IndexPath.random
        searchViewModel.stub(identifier, forDealerAt: indexPath)
        let viewModelFactory = FakeDealersViewModelFactory(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(identifier, context.delegate.capturedSelectedDealerIdentifier)
    }

}
