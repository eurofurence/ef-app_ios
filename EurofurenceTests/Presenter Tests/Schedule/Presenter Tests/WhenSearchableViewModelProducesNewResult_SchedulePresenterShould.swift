@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSearchableViewModelProducesNewResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToBindExpectedNumberOfResultsPerSection() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        let expected = results.map(\.events.count)
        searchViewModel.simulateSearchResultsUpdated(results)

        XCTAssertEqual(expected, context.scene.boundSearchItemsPerSection)
    }

}
