import EurofurenceModel
import ScheduleComponent
import XCTest

class WhenSceneUpdatesSearchQuery_SchedulePresenterShould: XCTestCase {

    func testTellTheSearchableViewModelToUpdateItsResults() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let expected = String.random
        context.simulateSceneDidUpdateSearchQuery(expected)

        XCTAssertEqual(expected, searchViewModel.capturedSearchInput)
    }

}
