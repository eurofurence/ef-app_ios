import Eurofurence
import EurofurenceModel
import XCTest

class WhenSearching_ScheduleViewModelFactoryShould: XCTestCase {

    func testChangeSearchTermToUsedInput() {
        let eventsService = FakeEventsService()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        let term = String.random
        searchViewModel?.updateSearchResults(input: term)

        XCTAssertEqual(term, eventsService.lastProducedSearchController?.capturedSearchTerm)
    }

}
