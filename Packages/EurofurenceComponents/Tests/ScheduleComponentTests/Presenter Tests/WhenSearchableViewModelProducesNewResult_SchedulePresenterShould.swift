import EurofurenceModel
import ScheduleComponent
import XCTest

class WhenSearchableViewModelProducesNewResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToBindExpectedNumberOfResultsPerSection() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        let expected = results.map(\.events.count)
        searchViewModel.simulateSearchResultsUpdated(results)

        XCTAssertEqual(expected, context.scene.boundSearchItemsPerSection)
    }

}
