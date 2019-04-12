@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenToldToFilterToFavouriteEvents_ScheduleInteractorShould: XCTestCase {

    func testTellTheSearchControllerToRestrictEventsToFavourites() {
        let eventsService = FakeEventsService()
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        let searchViewModel = context.makeSearchViewModel()
        searchViewModel?.filterToFavourites()

        XCTAssertEqual(true, eventsService.lastProducedSearchController?.didRestrictSearchResultsToFavourites)
    }

}
