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
        
        let expected = EventContainsSearchTermSpecification(query: term)
        let actual = eventsService.schedule(for: "Schedule Search")?.specification

        XCTAssertEqual(expected.eraseToAnySpecification(), actual)
    }

}
