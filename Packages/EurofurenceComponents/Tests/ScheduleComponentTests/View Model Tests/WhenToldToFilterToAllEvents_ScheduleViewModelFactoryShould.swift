import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenToldToFilterToAllEvents_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheSearchControllerToLifeTheFavouritesRestriction() {
        let eventsService = FakeEventsService()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToAllEvents()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didLiftFavouritesSearchRestriction)
    }

}
