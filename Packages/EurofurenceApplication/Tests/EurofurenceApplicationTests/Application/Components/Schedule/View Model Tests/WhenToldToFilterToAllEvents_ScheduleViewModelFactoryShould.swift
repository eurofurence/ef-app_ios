import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenToldToFilterToAllEvents_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheSearchControllerToLifeTheFavouritesRestriction() {
        let eventsService = FakeEventsService()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToAllEvents()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didLiftFavouritesSearchRestriction)
    }

}
