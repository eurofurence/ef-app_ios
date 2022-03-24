import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenToldToFilterToAllEvents_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheSearchControllerToLifeTheFavouritesRestriction() {
        let eventsService = FakeScheduleRepository()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToAllEvents()
        
        let expected = EventContainsSearchTermSpecification(query: "")
        let actual = eventsService.schedule(for: "Schedule Search")?.specification

        XCTAssertEqual(expected.eraseToAnySpecification(), actual)
    }

}
