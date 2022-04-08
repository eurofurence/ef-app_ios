import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenToldToFilterToFavouriteEvents_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheSearchControllerToRestrictEventsToFavourites() {
        let eventsService = FakeScheduleRepository()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToFavourites()
        
        let expected = EventContainsSearchTermSpecification(query: "") && IsFavouriteEventSpecification()
        let actual = eventsService.schedule(for: "Schedule Search")?.specification

        XCTAssertEqual(expected.eraseToAnySpecification(), actual)
    }

}
