import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenSearching_ScheduleViewModelFactoryShould: XCTestCase {

    func testChangeSearchTermToUsedInput() {
        let eventsService = FakeScheduleRepository()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        let term = String.random
        searchViewModel?.updateSearchResults(input: term)

        XCTAssertEqual(term, eventsService.lastProducedSearchController?.capturedSearchTerm)
    }

}
