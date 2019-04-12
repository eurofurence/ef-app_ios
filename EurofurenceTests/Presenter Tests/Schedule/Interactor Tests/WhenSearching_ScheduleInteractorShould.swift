@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSearching_ScheduleInteractorShould: XCTestCase {

    func testChangeSearchTermToUsedInput() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        let term = String.random
        searchViewModel?.updateSearchResults(input: term)

        XCTAssertEqual(term, eventsService.lastProducedSearchController?.capturedSearchTerm)
    }

}
