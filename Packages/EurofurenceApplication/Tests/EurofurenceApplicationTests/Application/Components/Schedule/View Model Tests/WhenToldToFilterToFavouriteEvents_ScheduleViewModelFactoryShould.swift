import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenToldToFilterToFavouriteEvents_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheSearchControllerToRestrictEventsToFavourites() {
        let eventsService = FakeEventsService()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToFavourites()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didRestrictSearchResultsToFavourites)
    }

}
